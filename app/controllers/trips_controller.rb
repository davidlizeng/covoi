class TripsController < ApplicationController

  before_filter :require_login

  def create
    @trip = Trip.new
    @trip.origin_id = params[:trip][:origin_id] || 0
    @trip.airport_id = params[:trip][:airport_id] || 0
    @trip.date = params[:trip][:date] || ""
    @trip.hour = params[:trip][:hour] || ""
    @trip.minute = params[:trip][:minute] || ""
    @trip.meridiem = params[:trip][:meridiem] || ""
    @trip.id = 0
    respond_to do |format|
      if @trip.valid?
        @trip.time = Trip.buildDateTime(@trip)
        @time = @trip.time.in_time_zone.to_s
        @origins = Origin.find_all_cached
        @airports = Airport.find_all_cached
        @trips = Trip.where(:airport_id => @trip.airport_id, :time => ((@trip.time - 60*60*1.5)..(@trip.time))).all
        @trips = @trips.sort{ |x, y| (@trip.time - x.time + 20*60*(@trip.origin_id - x.origin_id).abs) <=> (@trip.time - y.time + 20*60*(@trip.origin_id - y.origin_id).abs)}
        matches = Match.find_all_by_user_id(current_user.id)
        @user_trips = [];
        matches.each do |m|
          @user_trips.push(m.trip_id)
        end
        format.js
      else
        format.js
      end
    end
  end
end
