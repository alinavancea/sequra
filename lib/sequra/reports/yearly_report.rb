module Sequra
  module Reports
    class YearlyReport
      def generate
        disbursements_by_year = DisbursementReport.new
                                  .generate_by_created_at
                                  .index_by(&:year)

        minimum_fees_by_year  = MinimumMonthlyFeesReport.new
                                  .generate
                                  .index_by(&:year)

        all_years = (disbursements_by_year.keys | minimum_fees_by_year.keys).sort

        all_years.map do |year|
          d = disbursements_by_year[year]
          m = minimum_fees_by_year[year]

          {
            year:                year,
            disbursements_count: d&.disbursements_count,
            sequra_commission:   d&.sequra_commission.to_f,
            merchant_amount:     d&.merchant_amount.to_f,
            monthly_fees_count:  m&.monthly_fees_count,
            minimum_monthly_fee: m&.minimum_monthly_commission.to_f
          }
        end
      end
    end
  end
end
