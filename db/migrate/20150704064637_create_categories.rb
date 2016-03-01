class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_name
      t.integer :company_id

      t.timestamps null: false
    end
  end
end
