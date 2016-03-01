Apipie.configure do |config|
  config.app_name                = "JobPortal"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/apipie"
  # where is your API defined?
  # config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/sessions_controller.rb"
  #config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/registrations_controller.rb" 
  #config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/profiles_controller.rb"
  #config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/companies_controller.rb"
  #config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/jobs_controller.rb"
  # config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
   config.api_controllers_matcher = "#{Rails.root}/app/controllers/api/v1/*.rb"
end
