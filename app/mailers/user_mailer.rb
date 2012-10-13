class UserMailer < ActionMailer::Base

  default :from => "noreply@ridegrouped.com"

  def registration_confirmation(user)
    @user = user
    mail(:to => @user.email, :subject => "Complete Registration")
  end

end
