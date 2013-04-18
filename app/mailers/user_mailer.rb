class UserMailer < ActionMailer::Base

  @@noreply = "\"RideGrouped\" <noreply@ridegrouped.com>"
  @@service = "\"RideGrouped Service\" <service@ridegrouped.com>"

  def registration_confirmation(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :bcc => @@service, :subject => "Complete Your Registration")
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
    mail(:from => @@service, :to => @user.email, :bcc => @@service, :subject => "Booking Confirmation")
  end

  def group_confirmation(email_string, matches, trip, origin)
    @matches = matches
    @trip = trip
    @origin = origin
    mail(:from => @@service, :to => email_string, :bcc => @@service, :subject => "RideGrouped Reservation Details - Important Travel Day Informtaion (READ IMMEDIATELY)")
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
    mail(:from => @@service, :to => match.user.email, :bcc => @@service, :subject => "Your RideGrouped Booking Receipt")
  end

  def password_reset(user)
    @user = user
    mail(:from => @@noreply, :to => @user.email, :bcc => @@service, :subject => "Password Reset Request")
  end

  def booking_cancellation(user, trip, match, origin)
    @user = user
    @trip = trip
    @match = match
    @origin = origin
    mail(:from => @@service, :to => @user.email, :bcc => @@service, :subject => "Booking Cancellation")
  end

  def booking_merge(user, trip, trip2, match, origin, origin2)
    @user = user
    @trip = trip
    @trip2 = trip2
    @match = match
    @origin = origin
    @origin2 = origin2
    mail(:from => @@service, :to => @user.email, :bcc => @@service, :subject => "Booking Update")
  end
end
