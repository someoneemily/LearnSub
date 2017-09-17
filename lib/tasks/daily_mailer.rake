namespace :daily_mailer do
  desc 'send daily list of related interest videos and topics'
  task send_daily_email: :environment do
  	User.all.each do |user| 
      UserMailer.send_daily_email(user.email).deliver
    end
  end
end