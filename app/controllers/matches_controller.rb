class MatchesController < ApplicationController

  before_filter :require_login

  def create
    @user = current_user
    @charge = ""
    @error = nil
    params[:trip][:id] = params[:trip][:id] || ""
    params[:trip][:origin_id] = params[:trip][:origin_id] || ""
    params[:trip][:airport_id] = params[:trip][:airport_id] || ""
    params[:trip][:time_id] = params[:trip][:time] || ""
    params[:trip][:card_token] = params[:trip][:card_token] || ""
    params[:donate_dollars] = params[:donate_dollars] || ""
    params[:donate_cents] = params[:donate_cents] || ""
    @donate = params[:donate_dollars] + "." + params[:donate_cents]
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    customer.card = params[:trip][:card_token]
    customer.save
    if params[:trip][:id].eql?("")
      @error = "Invalid trip selection"
    end
    respond_to do |format|
      if @error.nil?
        if !params[:trip][:id].eql?("0")
          @join = true
          @trip = Trip.find_by_id(params[:trip][:id])
          if !@trip
            @error = "Invalid trip selection"
          elsif !(@donate.to_s =~ /^[0-9]\.[0-9]{2}$/)
            @error = "Donations must be of the format $x.xx"
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
          else
            begin
              @trip.id = SecureRandom.random_number(900000000)+100000000
            end while Trip.find_by_id(@trip.id) != nil
            @trip.time_created = Time.now
            @trip.save
            customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
            customer.account_balance = customer.account_balance + 2000
            customer.save
          end
        end

        if @error.nil?
          @match = Match.new
          begin
            @match.id = SecureRandom.random_number(9000000000)+1000000000
          end while Match.find_by_id(@match.id) != nil
          @match.trip_id = @trip.id
          @match.user_id = @user.id
          @match.time_created = Time.now
          @match.save
          UserMailer.booking_confirmation(@user, @trip, @match, Origin.find_by_id_cached(@trip.origin_id), @join, @donate, @charge).deliver
        end
        format.js
      end
    end
  rescue Stripe::InvalidRequestError => e
    @error = "Error processing credit card. Please try again."
    respond_to do |format|
      format.js
    end
  end
end
