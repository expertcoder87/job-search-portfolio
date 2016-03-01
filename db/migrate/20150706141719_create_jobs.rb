class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
    	t.string :title
    	t.text   :description
    	t.string :company_name
    	t.string :category_name
    	t.boolean :featured,default: :false
    	t.string :url
    	t.integer :company_id
      t.integer :category_id
    	
      t.timestamps null: false
    end
  end
end
