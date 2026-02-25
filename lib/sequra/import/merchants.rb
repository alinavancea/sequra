module Sequra
  module Import
    class Merchants
      def initialize(file_path)
        @file_path = file_path
      end

      def import
        errors = []

        CSV.foreach(@file_path, headers: true, col_sep: ";") do |row|
          create_merchant(row)
        rescue => error
          errors << { reference: row["reference"], error: error.message }
          Rails.logger.error(error.message)
        end

        errors
      end

      private

      def create_merchant(row)
        Merchant.find_or_create_by!(reference: row["reference"]) do |merchant|
          merchant.id = row["id"]
          merchant.email = row["email"]
          merchant.live_on = row["live_on"]
          merchant.disbursement_frequency = row["disbursement_frequency"]
          merchant.minimum_monthly_fee = row["minimum_monthly_fee"].to_f
        end
      end
    end
  end
end
