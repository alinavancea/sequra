class CreateMerchants < ActiveRecord::Migration[8.1]
  def change
    create_table :merchants, id: :uuid do |t|
      t.string :reference, null: false
      t.string :email, null: false
      t.integer :disbursement_frequency, default: 0, null: false
      t.decimal :minimum_monthly_fee, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
