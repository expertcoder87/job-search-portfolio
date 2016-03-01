class Api::V1::SessionsController < Devise::SessionsController
  respond_to :json
  skip_before_action :verify_authenticity_token
  skip_before_filter :require_no_authentication, :only => [:create]
  before_filter :ensure_params_exist,:only=>[:create]

  def_param_group :user do
    param :user, Hash,:desc => "User info",:action_aware => true,:required=>true do
    param :email,String, "User SignIn",:required => true
    param :password,String,"User Password For SignIn",:required => true
    end
  end

  api :POST, "/sign_in", "User SignIn"
  param_group :user

  def create 
    resource = User.find_for_database_authentication(email: params[:user][:email])
      return invalid_login_attempt unless resource
      if resource.valid_password?(params[:user][:password])
          if resource.confirmed_at.present?
             sign_in("user", resource)
               render :json => {:success => true,:message => "Your Account Logged In Successfully",user: UserSerializer.new(resource).as_json(root: false)}
          else
              render :json => {success: false,message: "Please Verify Your E-Mail"}
          end
          return
       end
        invalid_login_attempt
  end

  api :DELETE, "/sign_out", "User SignOut"

  def destroy 
    render :json => {:success => true,:message => "Your Account Logged Out Successfully",user: UserSerializer.new(current_user).as_json(root: false) }
    sign_out(current_user)
  end

  protected

  def ensure_params_exist
    return unless params[:user].blank?
      render :json => {success: false,message: "Missing User Parameter"},status: 422
  end

  def invalid_login_attempt
    warden.custom_failure!
      render :json => {success: false,message: "Error with your Email or password"}, status: 401
    end
end