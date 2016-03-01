class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
    	t.string :name
    	t.string :username
    	t.string :email
    	t.string :country
    	t.string :state
    	t.string :city
    	t.integer :number_days_purchased
    	t.integer :number_days_remaining
    	t.string :company_jobs
    	t.integer :price_id

      t.timestamps null: false
    end
  end
end
