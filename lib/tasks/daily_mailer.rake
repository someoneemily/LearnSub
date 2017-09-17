namespace :daily_mailer do
  desc 'send daily list of related interest videos and topics'
  task send_daily_email: :environment do
      UserMailer.send_daily_email("iemily.cwx@gmail.com").deliver
  end
end