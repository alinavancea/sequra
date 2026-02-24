module Sequra
  module Reports
    class MinimumMonthlyFeesReport
      def generate
        # Consider status processed here
        MerchantMinimumMonthlyCommission
          .group("DATE_PART('year', merchant_minimum_monthly_commissions.created_at::date)")
          .select("DATE_PART('year', merchant_minimum_monthly_commissions.created_at::date) AS year, COUNT(id) AS monthly_fees_count, SUM(minimum_monthly_comission) AS minimum_monthly_comission")
      end
    end
  end
end
