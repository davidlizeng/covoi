class PaymentsController < ApplicationController
  def new
  end

  def create
    #customer = Stripe::Customer.create(
    #    :card => params[:trip][:token],
    #    :description => current_user.email
    #)
    Stripe::Charge.create(
        :amount => 1500,
        :currency => "usd",
        :card => params[:trip][:card_token]
    )
    @trip = Trip.new
    @trip.origin = params[:trip][:origin]
    @trip.destination = params[:trip][:destination]
    begin
      @trip.id = SecureRandom.random_number(90000000000000) + 10000000000000
    end while Trip.find_by_id(@trip.id) != nil
    @trip.save
    @match = Match.new
    @match.trip_id = @trip.id
    @match.user_id = current_user.id
    @match.save
    redirect_to user_path(current_user.id)
  rescue Stripe::InvalidRequestError => e  
    @trip = Trip.new
    @trip.origin = params[:trip][:origin]
    @trip.destination = params[:trip][:destination]
    flash[:error] = e.message
    render :new
  end

end
