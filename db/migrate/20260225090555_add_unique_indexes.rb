class AddUniqueIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :orders, :external_id, unique: true
    add_index :merchants, :reference, unique: true
    add_index :disbursements, :reference, unique: true
  end
end
