class Api::V1::PricesController < ApplicationController

	def index
	  if current_user.has_role? :admin
	    @prices = Price.all
		render json: @prices		
	  else
		render :json=>{:success=>false,:message=>"You need to login with authorized role"}
	  end
    end
end