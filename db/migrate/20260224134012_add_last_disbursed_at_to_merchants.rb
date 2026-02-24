class AddLastDisbursedAtToMerchants < ActiveRecord::Migration[8.1]
  def change
    add_column :merchants, :last_disbursed_date, :date, default: -> { "CURRENT_TIMESTAMP" }
  end
end
