class Api::V1::CompaniesController < ApplicationController
	respond_to :json
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_no_authentication

	def_param_group :company do
	  param :name,String, "Name of Company"
	  param :username, String, "Name of the Company Username"
	  param :email,String,"Company Email Address"
	  param :country,String,"Company Existing Country"
	  param :state,String,"Company Existing State"
	  param :city,String,"Company Existing City" 
	  param :number_days_purchased,Integer,"No Of days job purchased company"
	  param :number_days_remaining,Integer,"No of days Remaining to Expire job"
	  param :price_id,Integer,"No of days Job Price"
	end

	api :POST, "/company/create", "Created an Company"
	param_group :company

	def create
		if current_user.present?
		  authorize! :manage, Company
		    if Price.exists?(:id=> params["company"]["price_id"].to_i) || !(params["company"][:price_id]).empty?
			  @price = Price.find(params["company"]["price_id"].to_i)
			  @company = @price.build_company(company_params)
			  @company.save
			 	render :json=>{:success=>true,:message=>"Company Successfully Created",company: CompanySerializer.new(@company).as_json(root: false)}
			else
			  render :json=>{:success=>false,:message=>"Invalid Price Details"}
			end
		else
		 render :json=>{:success=>false,:message=>"You need to be logged in"}
		end
	end

	api :GET, "/companies", "Index all Companies"

	def index
	  if current_user.present?
	    if params["name"].present?
	      @company = Company.where('name LIKE ?',"%#{params[:name]}%")
		  render json: @company
	    else	
	      @companies = Company.all
		  render json: @companies
	    end
	  else
	 	render :json=>{:success=>false,:message=>"You need to be logged in"}
	  end	
	end


	api :GET, "/company/:id", "Show Specific Company"
	param :id, :number

	def show
	 if current_user.present?
	   authorize! :read, Company
	     if Company.exists?(:id=> params["id"].to_i)
		   @company = Company.find(params["id"].to_i)
		   render :json=>{:success=>true,:message=>"Company Details",company: CompanySerializer.new(@company).as_json(root: false)}
		 else
		  render :json=>{:success=>false,:message=>"Company details does not exists"}
		 end
	 else
	 	render :json=>{:success=>false,:message=>"You need to be logged in"}
	 end
	end

	api :PUT, "/company/:id/update", "Update an Company"
	param :id, :number
	param_group :company

	def update
	  if current_user.present?
	    authorize! :manage, Company
		  if Company.exists?(:id => params["id"].to_i)
		   @company = Company.find_by_id(params["id"].to_i)
		   @company.update_attributes(company_params)
		   render :json=>{:success=>true,:message=>"Company Successfully Updated",company: CompanySerializer.new(@company).as_json(root: false)}
		  else
		   render :json=>{:success=>false,:message=>"Company details does not exists"}
		  end
	  else
		render :json=>{:success=>false,:message=>"You need to be logged in"}
	  end
	end

	api :DELETE, "/company/:id/destroy", "Delete an Company"
	param :id, :number

	def destroy
	  if current_user.present?
	    authorize! :delete, Company
		  if Company.exists?(:id => params["id"].to_i)
		    @company = Company.find_by_id(params["id"].to_i)
			@company.destroy
			render :json=>{:success=>true,:message=>"Company Successfully Deleted",company: CompanySerializer.new(@company).as_json(root: false)}				
		  else
			render :json=>{:success=>false,:message=>"Company details does not exists"}
		  end
	  else
	   render :json=>{:success=>false,:message=>"You need to be logged in"}
	  end
	end

	private
		def company_params
			params.require(:company).permit(:name,:username,:email,:country,:state,:city,:number_days_purchased,:number_days_remaining)
		end
end