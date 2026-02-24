module Sequra
  module Services
    class Disburse
      def self.run
        # TODO:
        # Handle minimum_monthly_fee
        # Handle the frequency
        # Should we process the orders grouped by merchant and processed_at date? In that case we would have a processed at date to
        Merchant.all.each do |merchant|
          pending_orders = merchant.orders.pending

          if pending_orders.any?
            total_amount = pending_orders.sum(:amount)

            sequora_commission_fee = Sequra::FeeCalculator.for_amount(total_amount)
            sequora_commission = Sequra::FeeCalculator.comssion_for_amount(total_amount)
            merchant_ammount_after_fee = Sequra::FeeCalculator.merchant_amount_after_fee(total_amount)

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
