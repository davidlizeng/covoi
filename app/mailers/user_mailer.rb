class UserMailer < ActionMailer::Base

  @@noreply = "\"RideGrouped\" <noreply@ridegrouped.com>"
  @@service = "\"RideGrouped Service\" <service@ridegrouped.com>"

  def registration_confirmation(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :subject => "Complete Registration")
  end

  def booking_confirmation(user, trip, match, origin, join, donate, charge)
    @user = user
    @trip = trip
    @match = match
    @origin = origin
    @donate = donate
    @charge = charge
    @join = join
    mail(:from => @@service, :to => @user.email, :subject => "Booking Confirmation")
  end

  def password_reset(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :subject => "Password Reset")
  end
end
