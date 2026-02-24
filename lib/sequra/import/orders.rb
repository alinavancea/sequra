module Sequra
  module Import
    class Orders
      # TODO
      # Think about loading the file directly to table, current approach can take long time and is not efficient
      # Consider adding to a file orders that could not be created
      def initialize(file_path)
        @file_path = file_path
        @merchants = Merchant.all
      end
      # col_sep could be a parameter here
      def import
        CSV.foreach(@file_path, headers: true, col_sep: ";") do |row|
          create_order(row)
        end
      end

      private

      def create_order(row)
        merchant = @merchants.find { |m| m.reference == row["merchant_reference"] }

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
