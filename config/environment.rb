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
