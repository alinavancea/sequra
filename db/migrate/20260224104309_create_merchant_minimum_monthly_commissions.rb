class CreateMerchantMinimumMonthlyCommissions < ActiveRecord::Migration[8.1]
  def change
    create_table :merchant_minimum_monthly_commissions, id: :uuid do |t|
      t.references :merchant, null: false, foreign_key: true, type: :uuid
      t.integer :status, default: 0, null: false
      t.decimal :minimum_monthly_comission, precision: 10, scale: 2, default: 0.0
      t.date :commission_date, null: false

      t.timestamps
    end
  end
end
