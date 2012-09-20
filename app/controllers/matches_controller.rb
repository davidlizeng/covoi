class MatchesController < ApplicationController
 
  before_filter :require_login

  def new
  end 

  def create
    if params[:trip_id] == "0"
      @trip = Trip.new
      @trip.origin_id = params[:trip][:origin_id]
      @trip.airport_id = params[:trip][:airport_id]
    else
      @trip = Trip.find_by_id(params[:trip_id])
    end
    render "payments/new" 
  end

end
