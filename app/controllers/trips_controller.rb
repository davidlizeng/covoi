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
    @trip.type = params[:trip][:type] || ""
    @trip.id = 0
    respond_to do |format|
      if @trip.valid?
        @trip.time = Trip.buildDateTime(@trip)
        @time = @trip.time.in_time_zone.to_s
        if @trip.time < Time.now + 24*60*60
          @error = "RideGrouped can only accomodate shuttle bookings at least 24 hours in advance. For last minute bookings, try SuperShuttle's site directly at supershuttle.com"
        end
        @origins = Origin.find_all_cached
        @airports = Airport.find_all_cached
        trips = Trip.where(:airport_id => @trip.airport_id, :time => ((@trip.time - 60*60*1)..(@trip.time + 60*10))).all
        trips = trips.sort{ |x, y| (@trip.time - x.time + 15*60*(@trip.origin_id - x.origin_id).abs) <=> (@trip.time - y.time + 15*60*(@trip.origin_id - y.origin_id).abs)}
        matches = Match.find_all_by_user_id(current_user.id)
        user_trips = [];
        matches.each do |m|
          puts m.trip_id
          user_trips.push(m.trip_id)
        end
        @trips = []
        puts trips[0].id
        trips.each do |t|
          puts t.id
          #unless user_trips.include?(t.id)
            @trips.push(t)
          #end
        end
        format.js
      else
        @error = @trip.errors.full_messages[0]
        format.js
      end
    end
  end
end
