require 'rubygems'
require 'rufus/scheduler'
# require "#{Rails.root}/lib/action_controller/metal/rack_delegation.rb"  

scheduler = Rufus::Scheduler.new

scheduler.every '1h' do
 system("rake job_notification:job_expire")
end

