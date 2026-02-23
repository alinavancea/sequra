class CreateDisrembursments < ActiveRecord::Migration[8.1]
  def change
    create_table :disrembursments, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true, type: :uuid
      t.string :reference
      t.integer :status, default: 0, null: false
      t.decimal :total_amount, precision: 10, scale: 2, default: 0.0
      t.decimal :sequora_commission_fee, precision: 10, scale: 4, default: 0.0
      t.decimal :sequora_commission, precision: 12, scale: 2, default: 0.0
      t.decimal :merchant_amount, precision: 12, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
