class MatchesController < ApplicationController

  before_filter :require_login

  def create
    @user = current_user
    @charge = ""
    @charge1 = ""
    @charge2 = ""
    @error = nil
    params[:trip][:id] = params[:trip][:id] || ""
    params[:trip][:origin_id] = params[:trip][:origin_id] || ""
    params[:trip][:airport_id] = params[:trip][:airport_id] || ""
    params[:trip][:time_id] = params[:trip][:time] || ""
    params[:trip][:card_token] = params[:trip][:card_token] || ""
    params[:donate_dollars] = params[:donate_dollars] || ""
    params[:donate_cents] = params[:donate_cents] || ""
    params[:phone] = params[:phone] || ""
    params[:password] = params[:password] || ""
    @donate = params[:donate_dollars] + "." + params[:donate_cents]
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    customer.card = params[:trip][:card_token]
    customer.save
    if params[:trip][:id].eql?("")
      @error = "Invalid trip selection"
    elsif !@user.authenticate(params[:password])
      @error = "Password is incorrect"
    elsif (params[:phone].to_s =~ /^[0-9]{10}$/).nil?
      @error = "Cell Phone Number must be 10 digits with no other characters"
    end
    respond_to do |format|
      if @error.nil?
        if !params[:trip][:id].eql?("0")
          @join = true
          @trip = Trip.find_by_id(params[:trip][:id])
          if !@trip
            @error = "Invalid trip selection"
          elsif !(@donate.to_s =~ /^[0-9]\.[0-9]{2}$/)
            @error = "Service Gratuity must be of the format $x.xx"
          elsif @trip.time < Time.now + 24*60*60
            @error = "RideGrouped can only accomodate shuttle bookings at least 24 hours in advance. For last minute bookings, try SuperShuttle's site directly at supershuttle.com"
          else
            charge = 1500 + (params[:donate_dollars].to_i)*100 + (params[:donate_cents].to_i)
            Stripe::Charge.create(
              :amount => charge,
              :currency => "usd",
              :customer => @user.stripe_customer_id
            )
            @charge = (15 + params[:donate_dollars].to_i).to_s + "." + params[:donate_cents]
          end
        else
          @join = false
          @trip = Trip.new
          @trip.creator_id = @user.id
          @trip.origin_id = params[:trip][:origin_id]
          @trip.airport_id = params[:trip][:airport_id]
          @trip.time = params[:trip][:time]
          @trip.id = 0
          if !@trip.valid?
            @error = @trip.errors.full_messages[0]
          elsif !(@donate.to_s =~ /^[0-9]\.[0-9]{2}$/)
            @error = "Service Gratuity must be of the format $x.xx"
          elsif @trip.time < Time.now + 24*60*60
            @error = "RideGrouped can only accomodate shuttle bookings at least 24 hours in advance. For last minute bookings, try SuperShuttle's site directly at supershuttle.com"
          else
            begin
              @trip.id = SecureRandom.random_number(9000000)+1000000
            end while Trip.find_by_id(@trip.id) != nil
            @trip.time_created = Time.now
            @trip.save
            customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
            customer.account_balance = customer.account_balance + 2000 + (params[:donate_dollars].to_i)*100 + (params[:donate_cents].to_i)
            customer.save
            @charge1 = (15 + params[:donate_dollars].to_i).to_s + "." + params[:donate_cents]
            @charge2 = (20 + params[:donate_dollars].to_i).to_s + "." + params[:donate_cents]
          end
        end

        if @error.nil?
          @match = Match.new
          begin
            @match.id = SecureRandom.random_number(90000000)+10000000
          end while Match.find_by_id(@match.id) != nil
          @match.trip_id = @trip.id
          @match.user_id = @user.id
          @match.group_id = 0
          @match.time_created = Time.now
          @match.save
          unless params[:phone].eql?(@user.phone)
            @user.phone = params[:phone]
            @user.save(:validate => false)
          end
          UserMailer.booking_confirmation(@user, @trip, @match, Origin.find_by_id_cached(@trip.origin_id), @join, @donate, @charge).deliver
        end
      end
      format.js
    end
  rescue
    @error = "Error processing credit card. Please try again."
    respond_to do |format|
      format.js
    end
  end
end
