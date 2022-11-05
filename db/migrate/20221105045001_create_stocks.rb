class CreateStocks < ActiveRecord::Migration[7.0]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.text :desc
      t.integer :value
      t.integer :count
      t.belongs_to :user, index:true, foreign_key:true

      t.timestamps
    end
  end
end
