class TripsController < ApplicationController
  
  before_filter :require_login 
  
  def new 
    @origin_models = Origin.find_all_cached
    @airport_models = Airport.find_all_cached
    @origin_choices = []
    @airport_choices = []
    @origin_models.each do |origin|
      @origin_choices.push([origin.name, origin.id])
    end
    @airport_models.each do |airport|
      if airport.terminal == ""
        @airport_choices.push([airport.code + " All Terminals, " + airport.city + ", " + airport.state, airport.id])
      else
        @airport_choices.push([airport.code + " " + airport.terminal + " Terminal, " + airport.city + ", " + airport.state, airport.id])
      end
    end
  end

  def create
    @trip = Trip.new
    @trip.origin_id = params[:trip][:origin_id]
    @trip.airport_id = params[:trip][:airport_id]
    
		if @trip.valid?
			@origins = Origin.find_all_cached
      @airports = Airport.find_all_cached
      @trips = Trip.all 
      render "matches/new"
		else
			flash.now[:error] = @trip.error.full_messages[0]
			render "new"
		end
  end
end
