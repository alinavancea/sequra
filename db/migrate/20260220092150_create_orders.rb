class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders, id: :uuid do |t|
      t.string :external_id, null: false
      t.references :merchant, null: false, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 10, scale: 2
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
