class MatchesController < ApplicationController

  include MatchesHelper
  before_filter :require_login

  def create
    @user = current_user
    @error = nil
    params[:trip][:id] = params[:trip][:id] || ""
    params[:trip][:origin_id] = params[:trip][:origin_id] || ""
    params[:trip][:airport_id] = params[:trip][:airport_id] || ""
    params[:trip][:time_id] = params[:trip][:time] || ""
    params[:trip][:card_token] =params[:trip][:card_token] || ""
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
      Stripe::Charge.create(
        :amount => 1500,
        :currency => "usd",
        :card => params[:trip][:card_token]
      )
      if @trip.id == 0
        begin
          @trip.id = SecureRandom.random_number(90000000000000)+10000000000000
        end while Trip.find_by_id(@trip.id) != nil
        @trip.save
      end
      @match = Match.new
      @match.trip_id = @trip.id
      @match.user_id = @user.id
      @match.save
      format.js
    end
  rescue Stripe::InvalidRequestError => e
    @error = "Error processing credit card. Please try again."
    respond_to do |format|
      format.js
    end
  end
end
