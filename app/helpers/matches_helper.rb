module MatchesHelper
  def buildInstanceVarsOnError(params)
    @trip = Trips.new
    @trip.origin_id = params[:trip][:origin_id]
    @trip.airport_id = params[:trip][:airport_id]
    @trip.time = params[:trip][:time]
    @trip.id = 0
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
    @trips = Trip.all
  end
end
