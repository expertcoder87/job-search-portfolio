class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable     

  has_many :users_roles
  has_many :roles, through: :users_roles

  has_one :profile

  def add_role(role)
    self.users_roles.create(role_id: role)
  end
	
  def has_role?(role)
    role = Role.find_by(name: role.to_s)
  	self.roles.include? role
  end
        
end
