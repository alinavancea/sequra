class AddDisbursementIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :orders, :disbursement, foreign_key: true, type: :uuid, index: true, null: true
  end
end
