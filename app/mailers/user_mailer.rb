class UserMailer < ApplicationMailer
  default :from => 'from_zeroto_pro@example.com'

  def send_daily_email(user_email)
    @data = `python3 untitled.py --q Minions --duration long`
    @data = @data.strip
    mail( :to => user_email,
    :subject => 'Your Daily List of Enlightenment' )
  end
end
