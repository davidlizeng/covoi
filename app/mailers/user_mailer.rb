class UserMailer < ActionMailer::Base

  default :from => "noreply@ridegrouped.com"
  default_url_options[:host] = SERVER_HOSTNAME

  def registration_confirmation(user)
    @user = user
    mail(:to => @user.email, :subject => "Complete Registration")
  end

end
