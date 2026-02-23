namespace :orders do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]
    merchants = Merchant.all
    # TODO
    # Think about loading the file directly to table, current approach can take long time and is not efficient
    # Consider adding to a file orders that could not be created
    # Consider a prcessed_at column to store the created_at
    CSV.foreach(file, headers: true, col_sep: ";") do |row|
      merchant = merchants.find { |m| m.reference == row["merchant_reference"] }

      Order.find_or_create_by!(external_id: row["id"]) do |order|
        order.amount = row["amount"]
        order.order_date = row["created_at"]
        order.merchant = merchant
      rescue => error
        p error
      end
    end
  end

  task disburse: :environment do
    # TODO:
    # Handle minimum_monthly_fee
    # Handle the frequency
    # Move the business logic into a module
    # Should we process the orders grouped by merchant and processed_at date? In that case we would have a processed at date to
    Merchant.all.each do |merchant|
      pending_orders = merchant.orders.pending

      if pending_orders.any?
        total_amount = pending_orders.sum(:amount)

        sequora_commission_fee = Sequra::FeeCalculator.for_amount(total_amount)
        sequora_commission = Sequra::FeeCalculator.comssion_for_amount(total_amount, sequora_commission_fee).round(2)
        merchant_ammount_after_fee = Sequra::FeeCalculator.merchant_amount_after_fee(total_amount, sequora_commission_fee).round(2)

        begin
          disbursement = Disbursement.create!(
            merchant_id: merchant.id,
            total_amount: total_amount,
            sequora_commission_fee: sequora_commission_fee,
            sequora_commission: sequora_commission,
            merchant_amount: merchant_ammount_after_fee,
            status: :paid
            )

          pending_orders.update_all(disbursement_id: disbursement.id, status: :processed)
        rescue => e
          p e
        end
      else
        p "No orders"
      end
    end
  end

  task report_disbursement_created_at: :environment do
    desc "Yearly report for disrembursments"
    yearly_report = Disbursement.paid
      .group("DATE_PART('year', disbursements.created_at::date)")
      .select("DATE_PART('year', disbursements.created_at::date) AS year, COUNT(id) as num, SUM(sequora_commission) as sequora_commission, SUM(merchant_amount) AS merchant_amount ")

    yearly_report.each do |row|
      p [ row.year, row.num, row.sequora_commission.to_f, row.merchant_amount.to_f ]
    end
  end

  task report_order_date: :environment do
    desc "Yearly report for orders created"
    yearly_report = Order.processed.joins(:disbursement)
      .group("DATE_PART('year', orders.order_date)")
      .select("DATE_PART('year', orders.order_date) AS year, COUNT(disbursements.id) as num, SUM(disbursements.sequora_commission) as sequora_commission, SUM(disbursements.merchant_amount) AS merchant_amount ")

    yearly_report.each do |row|
      p [ row.year, row.num, row.sequora_commission.to_f, row.merchant_amount.to_f ]
    end
  end
end
