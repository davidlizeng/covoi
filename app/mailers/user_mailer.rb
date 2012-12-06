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
    mail(:from => @@service, :to => email_string, :subject => "RideGrouped Reservation Details - Important Travel Day Informtaion (READ IMMEDIATELY)")
  end

  def booking_receipt(match, amount, grouped)
    @first_name = match.user.first_name
    if grouped
      @gratuity = amount - 1500
    else
      @gratuity = amount - 2000
    end
    @amount = amount
    @grouped = grouped
    mail(:from => @@service, :to => match.user.email, :subject => "Your RideGrouped Booking Receipt")
  end

  def password_reset(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :subject => "Password Reset Request")
  end
end
