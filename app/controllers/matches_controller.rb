class MatchesController < ApplicationController

  before_filter :require_login

  def create
    @user = current_user
    @error = nil
    params[:trip][:id] = params[:trip][:id] || ""
    params[:trip][:origin_id] = params[:trip][:origin_id] || ""
    params[:trip][:airport_id] = params[:trip][:airport_id] || ""
    params[:trip][:time_id] = params[:trip][:time] || ""
    params[:trip][:card_token] = params[:trip][:card_token] || ""
    customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
    customer.card = params[:trip][:card_token]
    customer.save
    respond_to do |format|
      if !params[:trip][:id].eql?("0")
        if params[:trip][:id].eql?("")
          @errors = "Invalid trip selection."
          format.js
        else
          @trip = Trip.find_by_id(params[:trip][:id])
          if !@trip
            @errors = "Invalid trip selection."
            format.js
          end
        end
      else
        @trip = Trip.new
        @trip.creator_id = @user.id
        @trip.origin_id = params[:trip][:origin_id]
        @trip.airport_id = params[:trip][:airport_id]
        @trip.time = params[:trip][:time]
        @trip.id = 0
        if !@trip.valid?
          @error = @trip.errors.full_messages[0]
          format.js
        end
      end
      if @trip.id == 0
        begin
          @trip.id = SecureRandom.random_number(900000000)+100000000
        end while Trip.find_by_id(@trip.id) != nil
        @trip.time_created = Time.now
        @trip.save
        customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
        customer.account_balance = customer.account_balance + 2000
        customer.save
      else
        Stripe::Charge.create(
          :amount => 1500,
          :currency => "usd",
          :customer => @user.stripe_customer_id
        )
      end
      @match = Match.new
      begin
          @match.id = SecureRandom.random_number(9000000000)+1000000000
      end while Match.find_by_id(@match.id) != nil
      @match.trip_id = @trip.id
      @match.user_id = @user.id
      @match.time_created = Time.now
      @match.save
      UserMailer.booking_confirmation(@user, @trip, @match, Origin.find_by_id_cached(@trip.origin_id)).deliver
      format.js
    end
  rescue Stripe::InvalidRequestError => e
    @error = "Error processing credit card. Please try again."
    respond_to do |format|
      format.js
    end
  end
end
