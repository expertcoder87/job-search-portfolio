class Api::V1::ProfilesController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_no_authentication
    
  def_param_group :profile do
    param :first_name, String, "User First name"
    param :last_name, String, "User First name"
    param :company_name,String,"Company Name"
    param :current_title,String,"Current Title"
    param :summary,Hash,"Additional optional facts about the user"
    param :skills,String,"Technical or Communication Skills" 
    param :experience_company,String,"Previous Companies"
    param :experience_title,String,"Experience Title"
    param :experience_start_date,Date,"Experience Start Date"
    param :experience_end_date,Date,"Experience End Date"
    param :experience_description,Hash,"Additional optional facts about the user"
    param :school_name,String,"School Name"
    param :major,String,"Major Subject"
    param :education_start_date,Date,"Education Start Date"
    param :education_end_date,Date,"Education End Date" 
    param :allow_to_be_searched,[true, false],"All to be searched"
    param :looking_for,String,"Looking For"
  end

  api :POST, "/profile/create", "Create an Profile"
  param_group :profile

  def create
    if current_user.present?
      authorize! :manage, Profile
        @profile = current_user.build_profile(profile_params)
        @profile.save
        render :json=>{:success=>true,:message=>"Profile Successfully Created!",profile: ProfileSerializer.new(@profile).as_json(root: false)}
    else
      render :json=>{:success=>false,:message=>"You need to be logged in"}
    end
  end

  api :GET, "/profiles", "Index all Profile"

  def index
    if current_user.present?
      authorize! :read, Profile
        @profiles = Profile.all
        render json: @profiles
    else
     render :json=>{:success=>false,:message=>"You need to be logged in"}
    end
  end

  api :GET, '/profile/:id',"Show Specific Profile"
  param :id, :number

  def show
    if current_user.present?
      authorize! :read, Profile
        if Profile.exists?(:id=> params["id"].to_i)
          @profile = Profile.find(params["id"].to_i)
          render :json=>{:success=>true,:message=>"Profile Details",profile: ProfileSerializer.new(@profile).as_json(root: false)} 
        else
          render :json=>{:success=> false,:message=> "Profile details does not exists"}
        end
    else
      render :json=>{:success=>false,:message=>"You need to be logged in"}
    end
  end

  api :PUT, "/profile/:id/update", "Update an Profile"
  param :id, :number
  param_group :profile


  def update
    if current_user.present?
      authorize! :manage, Profile
        if Profile.exists?(:id => params["id"].to_i)
      	  @profile = Profile.find(params[:id].to_i)
          @profile.update_attributes(profile_params)
          render :json=>{:success=>true,:message=>"Profile Successfully Updated",profile: ProfileSerializer.new(@profile).as_json(root: false)}
        else
          render :json=> {:success=>false,:message=> "Profile details does not exists"} 
        end
    else
        render :json=>{:success=>false,:message=>"You need to be logged in"}   
    end
  end

  api :DELETE, "/profile/:id/destroy", "Delete an Profile"
  param :id, :number

  def destroy
    if current_user.present?
      authorize! :delete, Profile
        if Profile.exists?(:id => params["id"].to_i)
        	@profile = Profile.find(params[:id].to_i)
        	@profile.destroy
          render :json=>{:success=>true,:message=>"Profile Successfully Deleted",profile: ProfileSerializer.new(@profile).as_json(root: false)}
        else
         render :json=> {:success=>false,:message=> "Profile details does not exists"}  
        end 
    else
      render :json=>{:success=>false,:message=>"You need to be logged in"}
    end 
  end

  private
    def profile_params
    	params.require(:profile).permit(:first_name,:last_name,:company_name,:current_title,:summary,:skills,:experience_company,:experience_title,:experience_start_date,:experience_end_date,:experience_description,:school_name,:major,:education_start_date,:education_end_date,:allow_to_be_searched,:looking_for)
    end	
end