module Sequra
  module Import
    class Orders
      def initialize(file_path)
        @file_path = file_path
        @merchants_cache = {}
      end

      def import
        CSV.foreach(@file_path, headers: true, col_sep: ";") do |row|
          create_order(row)
        end
      end

      private

      def find_merchant(reference)
        @merchants_cache[reference] ||= Merchant.find_by(reference: reference)
      end

      def create_order(row)
        merchant = find_merchant(row["merchant_reference"])

        Order.find_or_create_by!(external_id: row["id"]) do |order|
          order.amount = row["amount"]
          order.order_date = row["created_at"]
          order.merchant = merchant
        end
      rescue => error
        Rails.logger.error(error.message)
      end
    end
  end
end
