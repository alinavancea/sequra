module Sequra
  module Services
    class Disburse
      def initialize(merchant)
        @merchant = merchant
      end

      def run
        return unless pending_orders.any?

        total_amount = pending_orders.sum(:amount)

        sequra_commission_fee = Sequra::FeeCalculator.rate_for_amount(total_amount)
        sequra_commission = Sequra::FeeCalculator.commission_for_amount(total_amount)
        merchant_amount_after_fee = Sequra::FeeCalculator.merchant_amount_after_fee(total_amount)

        ActiveRecord::Base.transaction do
          disbursement = Disbursement.create!(
            merchant_id: @merchant.id,
            total_amount: total_amount,
            sequra_commission_fee: sequra_commission_fee,
            sequra_commission: sequra_commission,
            merchant_amount: merchant_amount_after_fee,
            status: :paid
          )

          pending_orders.update_all(disbursement_id: disbursement.id, status: :processed)
          @merchant.update!(last_disbursed_date: Time.now.utc.to_date)

          disbursement
        end
      rescue => error
        pending_orders.update_all(status: :failed)
        Rails.logger.error(error.message)
        nil
      end

      private

      def pending_orders
        @pending_orders ||= @merchant.orders.pending
      end
    end
  end
end
