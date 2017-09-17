class UserMailer < ApplicationMailer
  default :from => 'from_zeroto_pro@example.com'

  def send_daily_email(user_email, interest)
  	@time = interest.time
  	@duration = ''
  	if @time <= 4
  		duration = 'short'
  	elsif @time >= 20
  		duration = 'long'
  	else
  		duration = 'medium'
  	end
    @data = `python3 untitled.py --q '"#{interest.topics}"' --duration '#{duration}'`
    @data = @data.strip
    mail( :to => user_email,
    :subject => 'Your Daily List of Enlightenment')
  end
end
