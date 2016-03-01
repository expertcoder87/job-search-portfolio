class Api::V1::RegistrationsController < Devise::RegistrationsController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_no_authentication

  def_param_group :user do
    param :user, Hash,:desc => "User info",:action_aware => true,:required=>true do
    param :email,String, "User autherized email",:required => true
    param :password,String,"User Password",:required => true
    param :password_confirmation,String,"User Confirmation Password",:required => true
    end
  end

 def_param_group :role do
    param :role, String,:desc => "Pass User Role only with Id, Role_id: 2=>Company','Role_id: 3=>hacker",:action_aware => true,:required=>true do
    end
  end
  
  api :POST, "/sign_up", "New User SignUp"
  param_group :user
  param_group :role

  def create 
    if params[:user][:email].blank? || params[:user][:password].blank? || params[:user][:password_confirmation].blank?
      render :status=>404,:json=>{:message => "Parameter Is Missing"}
    	return
    else			
        @user = User.create(user_params)		 	
          if @user.save
         	  @user.add_role params[:role]
            render :json => {:success => true,:message => "You Have Successfully Registered",user: UserSerializer.new(@user).as_json(root: false)}
            return
         	else		 		
            render json: @user.errors, status: 422
        		return
         	end	
     end
  end

  private
    def user_params
       params.require(:user).permit(:email, :password,:password_confirmation)
    end
end 