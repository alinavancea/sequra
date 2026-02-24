namespace :disbursement do
  task report_by_created_at: :environment do
    desc "Yearly report for disrembursments by created_at date"
    yearly_report = Sequra::Reports::DisbursementReport.new.generate_by_created_at

    yearly_report.each do |row|
      p [ row.year, row.disbursements_count, row.sequra_commission.to_f, row.merchant_amount.to_f ]
    end
  end

  task report_by_order_date: :environment do
    desc "Yearly report for disrembursments by order date"
    yearly_report = Sequra::Reports::DisbursementReport.new.generate_by_order_at

    yearly_report.each do |row|
      p [ row.year, row.disbursements_count, row.sequra_commission.to_f, row.merchant_amount.to_f ]
    end
  end

  task merchant_minimum_monthly_fee: :environment do
    # Every first day of the month

    first_day_of_last_month = Time.now.utc.beginning_of_month.last_month
    last_day_of_last_month = first_day_of_last_month.at_end_of_month
    last_month_interval = first_day_of_last_month .. last_day_of_last_month

    Sequra::Services::MinimumMonthlyFees.new.calculate(last_month_interval)
  end
end
