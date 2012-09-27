class TripsController < ApplicationController
  
  before_filter :require_login 
  
  def new 
    origins = Origin.find_all_cached
    airports = Airport.find_all_cached
    @origin_choices = Origin.buildOriginChoices(origins)
    @airport_choices = Airport.buildAirportChoices(airports)
  end

  def create
    @trip = Trip.new
    @trip.origin_id = params[:trip][:origin_id]
    @trip.airport_id = params[:trip][:airport_id]
		@trip.date = params[:trip][:date]
    @trip.hour = params[:trip][:hour]
    @trip.minute = params[:trip][:minute]
    @trip.meridiem = params[:trip][:meridiem]
    @trip.id = 0
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
		if @trip.valid?
      @trips = Trip.all 
      @trip.time = Trip.buildDateTime(@trip)
      @time = @trip.time.in_time_zone.to_s
      render "matches/new"
		else
			flash.now[:error] = @trip.errors.full_messages[0]
      @origin_choices = Origin.buildOriginChoices(@origins)
      @airport_choices = Airport.buildAirportChoices(@airports)
      render "new"
		end
  end
end
