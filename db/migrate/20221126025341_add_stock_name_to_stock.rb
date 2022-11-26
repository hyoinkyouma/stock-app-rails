class AddStockNameToStock < ActiveRecord::Migration[7.0]
  def change
    add_column :stocks, :stock_name, :string
  end
end
