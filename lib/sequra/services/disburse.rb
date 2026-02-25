module Sequra
  module Services
    class Disburse
      def initialize(merchant)
        @merchant = merchant
      end

      def pending_orders
        @pending_orders ||= @merchant.orders.pending
      end

      def run
        if pending_orders.any?
          total_amount = pending_orders.sum(:amount)

          sequra_commission_fee = Sequra::FeeCalculator.for_amount(total_amount)
          sequra_commission = Sequra::FeeCalculator.commission_for_amount(total_amount)
          merchant_ammount_after_fee = Sequra::FeeCalculator.merchant_amount_after_fee(total_amount)

          begin
            disbursement = Disbursement.create!(
              merchant_id: @merchant.id,
              total_amount: total_amount,
              sequra_commission_fee: sequra_commission_fee,
              sequra_commission: sequra_commission,
              merchant_amount: merchant_ammount_after_fee,
              status: :paid
              )

            pending_orders.update_all(disbursement_id: disbursement.id, status: :processed)
            @merchant.update(last_disbursed_date: Time.now.utc.to_date)

            disbursement
          rescue => error
            # We could adjust status here to failed
            Rails.logger.error(error.message)
          end
        else
          Rails.logger.info("No orders")
        end
      end
    end
  end
end
