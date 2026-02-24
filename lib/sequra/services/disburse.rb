module Sequra
  module Services
    class Disburse
      def initialize(frequency)
        @frequency = frequency
      end

      def merchants_with_frequency
        Merchant.where(disbursement_frequency: @frequency)
      end

      def run
        # TODO:
        # Handle the frequency
        # Should we process the orders grouped by merchant and processed_at date? In that case we would have a processed at date to
        merchants_with_frequency.each do |merchant|
          pending_orders = merchant.orders.pending

          if pending_orders.any?
            total_amount = pending_orders.sum(:amount)

            sequra_commission_fee = Sequra::FeeCalculator.for_amount(total_amount)
            sequra_commission = Sequra::FeeCalculator.comssion_for_amount(total_amount)
            merchant_ammount_after_fee = Sequra::FeeCalculator.merchant_amount_after_fee(total_amount)

            begin
              disbursement = Disbursement.create!(
                merchant_id: merchant.id,
                total_amount: total_amount,
                sequra_commission_fee: sequra_commission_fee,
                sequra_commission: sequra_commission,
                merchant_amount: merchant_ammount_after_fee,
                status: :paid
                )

              pending_orders.update_all(disbursement_id: disbursement.id, status: :processed)
            rescue => error
              Rails.logger.error(error.message)
            end
          else
            Rails.logger.info("No orders")
          end
        end
      end
    end
  end
end
