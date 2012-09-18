class MatchesController < ApplicationController
  def new
  end 

  def create
    @trip = Trip.new
    @trip.origin_id = params[:trip][:origin_id]
    @trip.airport_id = params[:trip][:airport_id]
    render "payments/new" 
  end

end
