class AddLiveOnColumnInMerchants < ActiveRecord::Migration[8.1]
  def change
    add_column :merchants, :live_on, :date, null: false
  end
end
