namespace :orders do
  task :import, [ :file_path ] => [ :environment ] do |t, args|
    file = args[:file_path]

    if file_path.present?
      if File.exist?(file_path)
        Sequra::Import::Orders.new(file).import
      else
        raise "File #{file_path} doesn't exist"
      end
    else
      raise "Needs file_path"
    end
  end

  task disburse: :environment do
    Sequra::Services::Disburse.run
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
