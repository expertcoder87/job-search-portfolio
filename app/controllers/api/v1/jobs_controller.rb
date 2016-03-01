class Api::V1::JobsController < ApplicationController
  respond_to :json
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_no_authentication
  before_action :authenticate_user!, :except => [:index,:create,:update,:destroy,:show]

  def_param_group :job do
    param :title,String, "Title of the Job"
    param :description,Hash, "Description about Job"
    param :company_name,String,"Name of the Company"
    param :category_name,String,"Name of Job Category Name"
    param :featured,[true,false],"Featured or Non Featured Job"
    param :url,String,"URL of Website" 
    param :category_id,Integer,"Category Id"
    param :company_id,Integer,"Company Id"
  end

  api :POST, "/job/create", "Create an Job"
  param_group :job

  def create
    if current_user.present?
      authorize! :manage, Job
        if Company.exists?(:id => params["job"]["company_id"].to_i) || !(params["job"][:company_id]).empty?
          if Category.exists?(:id => params["job"]["category_id"].to_i) || !(params["job"][:category_id]).empty?
              @company = Company.find(params["job"]["company_id"].to_i)
              price_id = Company.find(params["job"]["company_id"].to_i).price_id
              no_of_days = Price.find(price_id).days
              no_of_jobs = Job.where(:company_id=>params["job"]["company_id"].to_i).count
                if no_of_jobs == no_of_days
                 render :json=>{:success=> false,:message=> "Unable to create job"}
                  return
                else
                  @job = @company.jobs.create(job_params)
                  render :json => {:success => true, :message => "Job Successfully Created",job: JobSerializer.new(@job).as_json(root: false)}
                  return
                end
          else
            render :json=>{:success=>false,:message=>"Category Details Not exists"}
            return
          end
        else
          render :json=> {:success=> false,:message=>"Company details does not exits!"}
          return    
        end
    else
      render :json=> {:success=>false,:message=>"You need to be Logged In"}
      return
    end
  end

  api :GET, "/jobs", "Index all Jobs"
  param :id,:number

  def index
    if !current_user.present?
        if Job.all.paginate(:per_page => 20, :page => params[:page]).empty?
            render :json=>{:message=>"Page Record does not exists!"}
        elsif params[:title].present?
          @job = Job.where('title LIKE ?',"%#{params[:title]}%").order("created_at DESC")
          render json: @job
        else
          @jobs = Job.order("featured DESC").paginate(:per_page => 20, :page => params[:page])
          render json: @jobs
        end  
    else
      if current_user.has_role? :admin
         if Job.all.paginate(:per_page => 20, :page => params[:page]).empty?
              render :json=>{:message=>"Page Record does not exists!"} 
          elsif params[:title].present?
                @job = Job.where('title LIKE ?',"%#{params[:title]}%").order("created_at DESC")
                render json: @job
              else
                @jobs = Job.all.order("created_at DESC").paginate(:per_page => 20, :page => params[:page])
                render :json => @jobs.map { |job| {:title => job.title,:description => job.description,:featured => job.featured,:url => job.url }}
              end
        else
          if Job.all.paginate(:per_page => 20, :page => params[:page]).empty?
              render :json=>{:message=>"Page Record does not exists!"} 
            elsif params[:title].present?
              @job = Job.where('title LIKE ?',"%#{params[:title]}%").order("created_at DESC")
              render json: @job
            else
              @jobs = Job.all.order("created_at DESC").paginate(:per_page => 20, :page => params[:page])
              render json: @jobs
          end
      end
    end
  end

  api :GET, "/job/:id", "Show Specific Job"
  param :id, :number

  def show
    if current_user.present?
      authorize! :read, Job
      if Job.exists?(:id=>params["id"].to_i)
         company_id = Job.find(params["id"].to_i).company_id
         no_of_days = Company.find(company_id).price.days.to_i
         start_date = Job.find(params["id"].to_i).created_at
         end_date = Job.find(params["id"].to_i).created_at + no_of_days.days
         expire_date = ((end_date - Time.zone.now)/1.days).to_i
         if expire_date == 0   
           @job = Job.find(params["id"].to_i)  
           expire_by_today = expire_date
           render :json=>{:success=>true,:Remaining_days_to_expire=>expire_by_today,:message=>"Job Expire by Today",job: JobSerializer.new(@job).as_json(root: false)} 
         else
           rem_to_expire_job =(((end_date-Time.zone.now)/1.day).to_i)
           @job = Job.find(params["id"].to_i)
           render :json=>{:success=>true,:Remaining_days_to_expire=>rem_to_expire_job,:message=>"Job Details",job: JobSerializer.new(@job).as_json(root: false)}
         end
      else
       render :json=>{:success=>false,:message=>"Job details does not exists"}
      end
    else
      render :json=>{:success=>false,:message=>"You need to be Logged In"}
    end
  end

  api :PUT, "/job/:id/update", "Update an Job"
  param :id, :number   
  param_group :job

  def update
    if current_user.present?
      authorize! :manage, Job
      if Job.exists?(:id => params["id"].to_i)
        @job = Job.find(params["id"].to_i)
        @job.update_attributes(job_params)
        render :json=>{:success=>true,:message=>"Job Successfully Updated",job: JobSerializer.new(@job).as_json(root: false)}
      else
        render :json=>{success: false,:message=>"Job Details does not exists"}
      end 
    else
      render :json=>{:success=>false,:message=>"You need to be Logged In"}   
    end
  end

  def destroy
    Job.all.each do |job|
      company_id = job.company_id
      no_of_days = Company.find(company_id).price.days.days
      start_date = job.created_at
      end_date = start_date + no_of_days 
      expire_date = Time.zone.now    
      if expire_date == end_date || expire_date >= end_date 
        job.delete
      end
    end  
    puts "bye"
  end

  private
     def job_params
        params.require(:job).permit(:title,:description,:company_name,:category_name,:featured,:url,:category_id,:company_id)
     end
end
