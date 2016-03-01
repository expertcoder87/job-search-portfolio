class ApplicationController < ActionController::Base
#before_action :authenticate_user!
#before_action :signed_in_user	
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  rescue_from CanCan::AccessDenied do |exception|
	  render json: {
		    success: false,
		    message: 'You are not a authorized person'
	  }
  end
end