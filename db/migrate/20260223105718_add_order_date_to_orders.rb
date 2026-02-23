class AddOrderDateToOrders < ActiveRecord::Migration[8.1]
  def change
    add_column :orders, :order_date, :date, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end
end
