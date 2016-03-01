class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
    	
      t.string :first_name
      t.string :last_name
      t.string :company_name
      t.string :current_title
      t.text :summary
      t.string :skills
      t.string :experience_company
      t.string :experience_title
      t.date :experience_start_date
      t.date :experience_end_date
      t.text :experience_description
      t.string :school_name
      t.string :major
      t.date :education_start_date
      t.date :education_end_date
      t.boolean :allow_to_be_searched
      t.string :looking_for
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
