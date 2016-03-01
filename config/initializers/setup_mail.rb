# require 'development_mail_interceptor'
# ActionMailer::Base.smtp_settings = {
#   	  address: "smtp.gmail.com",
#       port: 587,
#       domain: "gmail.com",
#       authentication: "plain",
#       enable_starttls_auto: true,
#       :user_name => 'yuvasofttest@gmail.com',
#       :password => 'yuva12345678',
# }
# ActionMailer::Base.default_url_options[:host] = "localhost:3000"
# Mail.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?
