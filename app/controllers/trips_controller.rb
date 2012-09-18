class TripsController < ApplicationController
  def new
  end

  def create
    @trip = Trip.new
    @trip.origin_id = params[:trip][:origin_id]
    @trip.airport_id = params[:trip][:airport_id]
    
		if @trip.valid?
			flash.now[:notice] = "trip confirmed"
			render "matches/new"
		else
			flash.now[:error] = "agag bad error"
			render "new"
		end
  end
end
