class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
    	t.string :currency
    	t.integer :days

      t.timestamps null: false
    end
  end
end
