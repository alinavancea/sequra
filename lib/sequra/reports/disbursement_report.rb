module Sequra
  module Reports
    class DisbursementReport
      def generate_by_created_at
        Disbursement.paid
          .group("DATE_PART('year', disbursements.created_at::date)")
          .select("DATE_PART('year', disbursements.created_at::date) AS year, COUNT(id) AS disbursements_count, SUM(sequra_commission) AS sequra_commission, SUM(merchant_amount) AS merchant_amount")
      end

      # This report needs more thinking
      def generate_by_order_at
        Order.processed.joins(:disbursement)
          .group("DATE_PART('year', orders.order_date)")
          .select("DATE_PART('year', orders.order_date) AS year, COUNT(DISTINCT(disbursements.id)) as disbursements_count, SUM(disbursements.sequra_commission) as sequra_commission, SUM(disbursements.merchant_amount) AS merchant_amount ")
      end
    end
  end
end
