class UserMailer < ActionMailer::Base

  @@noreply = "\"RideGrouped\" <noreply@ridegrouped.com>"
  @@service = "\"RideGrouped Service\" <service@ridegrouped.com>"

  def registration_confirmation(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :subject => "Complete Your Registration")
  end

  def booking_confirmation(user, trip, match, origin, join, donate, charge, charge1, charge2)
    @user = user
    @trip = trip
    @match = match
    @origin = origin
    @donate = donate
    @charge = charge
    @charge1 = charge1
    @charge2 = charge2
    @join = join
    mail(:from => @@service, :to => @user.email, :subject => "Booking Confirmation")
  end

  def group_confirmation(email_string, matches, trip, origin)
    @matches = matches
    @trip = trip
    @origin = origin
    mail(:from => @@service, :to => email_string, :subject => "Your RideGroup's Information")
  end

  def password_reset(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :subject => "Password Reset Request")
  end
end
