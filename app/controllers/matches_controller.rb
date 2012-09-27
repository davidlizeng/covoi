class MatchesController < ApplicationController
  include MatchesHelper 
  before_filter :require_login

  def new
  end 

  def create
    if !params[:trip_id].eql?("0")
      @trip = Trip.find_by_id(params[:trip_id])
      if !@trip
        buildInstanceVarsOnErrors(params)
        flash.now[:error] = "Grotesque you."
        render "new"
      end
    else
      @trip = Trip.new
      @trip.creator_id = current_user.id
      @trip.origin_id = params[:trip][:origin_id]
      @trip.airport_id = params[:trip][:airport_id]
      @trip.time = params[:trip][:time]
      @trip.id = 0
      if !@trip.valid?
        buildInstanceVarsOnErrors(params)
        flash.now[:error] = "Grotesque you as well."
        render "new"
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
    @match.user_id = current_user.id
    @match.save
    redirect_to user_path(current_user.id)
  rescue Stripe::InvalidRequestError => e
    buildInstanceVarsOnErrors(params)
    flash.now[:error] = e.message
    render "new"
  end
end
