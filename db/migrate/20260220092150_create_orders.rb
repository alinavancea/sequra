class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.string :uuid
      t.references :merchant, null: false, foreign_key: true, type: :uuid
      t.decimal :amount, precision: 10, scale: 2
      t.integer :status, default: 0, null: false

      t.timestamps
    end
  end
end
