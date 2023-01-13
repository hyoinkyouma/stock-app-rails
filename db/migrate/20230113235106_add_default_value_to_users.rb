class AddDefaultValueToUsers < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :balance, :integer, :default => 20000
    change_column :users, :is_active, :boolean, :default => false
    change_column :users, :admin, :boolean, :default => false
  end
end
