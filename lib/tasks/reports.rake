namespace :reports do
  task yearly: :environment do
    desc "Yearly report for disrembursments by created_at date"
    yearly_report = Sequra::Reports::YearlyReport.new.generate

    yearly_report.each do |row|
      p row
    end
  end

  task disbursements: :environment do
    desc "Yearly report for disrembursments by created_at date"
    yearly_report = Sequra::Reports::DisbursementReport.new.generate_by_created_at

    p [ "year", "disbursements_count", "sequra_commission", "merchant_amount" ]
    yearly_report.each do |row|
      p [ row.year, row.disbursements_count, row.sequra_commission.to_f, row.merchant_amount.to_f ]
    end
  end

  task merchant_minimum_monthly_fees: :environment do
    desc "Yearly report for mimum monthly fees"
    yearly_report = Sequra::Reports::MinimumMonthlyFeesReport.new.generate

    p [ "year", "monthly_fees_count", "minimum_monthly_comission" ]
    yearly_report.each do |row|
      p [ row.year, row.monthly_fees_count, row.minimum_monthly_comission.to_f ]
    end
  end
end
