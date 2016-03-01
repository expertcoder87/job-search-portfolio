# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
 # admin = User.createemail: 'admin@admin.com', password: '12345678',)

#category entries
 categories = Category.create([{category_name: 'Developer'},{category_name: 'Sales'}])
#price entries
price = Price.create(:currency=>"$5",:days=>"1")
price = Price.create(:currency=>"$10",:days=>"3")
price = Price.create(:currency=>"$30",:days=>"10")
#role entries
['admin','company', 'hacker'].each do |role|
  Role.create({name: role})
end
#user entries
admin = User.create(:email=>'admin@gmail.com',:password=>"12345678",:password_confirmation=>"12345678")
admin.add_role "1"
admin.skip_confirmation!
