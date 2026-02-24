class RenameSequoraCommissionAndSequoraCommissionFee < ActiveRecord::Migration[8.1]
  def change
    rename_column :disbursements, :sequora_commission_fee, :sequra_commission_fee
    rename_column :disbursements, :sequora_commission, :sequra_commission
  end
end
