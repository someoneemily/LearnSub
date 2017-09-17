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
