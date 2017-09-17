namespace :daily_mailer do
  desc 'send daily list of related interest videos and topics'
  task send_daily_email: :environment do
  	User.all.each do |user|
  	  interests = Interest.all.where(user_id: user.id)
      if interests.size > 0
        interest = interests[Random.new.rand(interests.size)]
        UserMailer.send_daily_email(user.email, interest).deliver
      end
    end
  end
end
