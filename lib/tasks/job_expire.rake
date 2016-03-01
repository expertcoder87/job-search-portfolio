namespace :job_notification do
  task :job_expire => :environment do
	job = Api::V1::JobsController.new
	job.destroy
 end  
end
