class AddDisrembursmentIdToOrders < ActiveRecord::Migration[8.1]
  def change
    add_reference :orders, :disrembursment, foreign_key: true, type: :uuid, index: true
  end
end
