class RenameMinimumMonthlyComissionToCommission < ActiveRecord::Migration[8.1]
  def change
    rename_column :merchant_minimum_monthly_commissions, :minimum_monthly_comission, :minimum_monthly_commission
  end
end
