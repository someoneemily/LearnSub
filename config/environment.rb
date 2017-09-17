# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
ActionMailer::Base.smtp_settings = {
  :user_name => 'apikey',
  :password => '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',
  :domain => 'apps.reddolution.com',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}

Rails.application.initialize!
