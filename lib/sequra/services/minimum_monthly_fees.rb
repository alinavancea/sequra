module Sequra
  module Services
    class MinimumMonthlyFees
      def calculate(time_interval)
        Merchant.find_each do |merchant|
          sequra_commission = merchant.disbursements.paid.for_interval(time_interval).sum(:sequra_commission)
          if sequra_commission < merchant.minimum_monthly_fee
            commission_to_pay = merchant.minimum_monthly_fee - sequra_commission

            merchant.merchant_minimum_monthly_commissions.create!(minimum_monthly_commission: commission_to_pay, commission_date: time_interval.first)
          end
        rescue => error
          # We could adjust status here to failed
          Rails.logger.error(error.message)
        end
      end
    end
  end
end
