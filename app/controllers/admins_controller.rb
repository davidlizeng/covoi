class AdminsController < ApplicationController

  before_filter :require_admin

  def show
    @user = current_user
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached

    @unconfirmed = []
    @user_count = User.where(:confirmed => true).count
    #@unbooked = []
    #@unbooked_count = @user_count - @matches.size
    @future = Time.now + 60*60*24*1000
    @after = Time.new(2012, 1, 1, 0, 0, 0, "-07:00")
    @before = Time.new(2013, 7, 1, 0, 0, 0, "-07:00")
    @airports_shown = [1, 2]
    @origins_shown = [1, 2, 3, 4]
    if !params[:after].nil?
      begin
        @after = Time.strptime(params[:after], "%m/%d/%Y").in_time_zone(Time.zone)
      rescue Exception => e
        @error = "Invalid value for parameter after"
      end
    end
    if !params[:before].nil?
      begin
        @before = Time.strptime(params[:before], "%m/%d/%Y").in_time_zone(Time.zone)
      rescue Exception => e
        @error = "Invalid value for parameter before"
      end
    end
    if !params[:hAirports].nil?
      hidden_airports = params[:hAirports].split(",").map { |s| @airports_shown.delete(s.to_i) }
    end
    if !params[:hOrigins].nil?
      hidden_origins = params[:hOrigins].split(",").map { |s| @origins_shown.delete(s.to_i) }
    end
    @matches = Match.includes(:trip, :user).where("trips.time >= ? AND trips.time <= ?", @after, @before).where("trips.origin_id" => @origins_shown).where("trips.airport_id" => @airports_shown).order("trips.time ASC, trips.id ASC, matches.time_created ASC")
    @solo = []
    @groups = []
    @grouped_count = 0
    cur = []
    if !@matches.empty?
      0.upto(@matches.size - 2) do |i|
        if @matches[i].trip_id == @matches[i+1].trip_id
          @grouped_count = @grouped_count + 1
          cur.push(@matches[i])
        elsif cur.size == 0
          @solo.push(@matches[i])
        else
          @grouped_count = @grouped_count + 1
          cur.push(@matches[i])
          @groups.push(cur)
          cur = []
        end
      end
      if cur.size != 0
        @grouped_count = @grouped_count + 1
        cur.push(@matches[@matches.size - 1])
        @groups.push(cur)
      else
        @solo.push(@matches[@matches.size - 1])
      end
    end
  end


  def create
    params[:trip_id] = params[:trip_id] || "0"
    params[:match_id] = params[:match_id] || "0"
    params[:group_id] = params[:group_id] || "0"
    params[:merge_id] = params[:merge_id] || "0"
    if params[:mode] == "group"
      if params[:trip_id] =~ /^[0-9]{7}$/ && params[:group_id] =~ /^[0-9]{7}$/
        @trip = Trip.find_by_id(params[:trip_id])
        if !@trip.nil?
          @mode = "group"
          @trip.group_id = params[:group_id]
          @trip.save(:validate => false)
          matches = Match.includes(:user).where(:trip_id => params[:trip_id]).order("matches.time_created ASC")
          emails = []
          matches.each do |m|
            emails.push(m.user.email)
          end
          email_string = emails.join(",")
          UserMailer.group_confirmation(email_string, matches, @trip, Origin.find_by_id_cached(@trip.origin_id)).deliver
          customer = Stripe::Customer.retrieve(matches.first.user.stripe_customer_id)
        else
          @error = "Could not find trip"
        end
      else
        @error = "Illegal input"
      end
    elsif params[:mode] == "merge"
      if params[:match_id] =~ /^[0-9]{8}$/ && params[:merge_id] =~ /^[0-9]{8}$/
        @mode = "merge"
        match = Match.find_by_id(params[:match_id])
        match2 = Match.find_by_id(params[:merge_id])
        if !match.nil? && !match2.nil?
          trip = Trip.find_by_id(match.trip_id)
          trip2 = Trip.find_by_id(match2.trip_id)
          if match.id != match2.id && trip.id != trip2.id
            match_count = Match.where(:trip_id => match.trip_id).count
            user = User.find_by_id(match.user_id)
            if match_count == 1
              trip.locked = true
              trip.save(:validate => false)
            end
            UserMailer.booking_merge(user, trip, trip2, match, Origin.find_by_id_cached(trip.origin_id), Origin.find_by_id_cached(trip2.origin_id)).deliver
            match.trip_id = trip2.id
            match.time_created = Time.now
            match.save
          else
            @error = "Cannot merge ride with itself"
          end
        else
          @error = "Match not found"
        end
      else
        @error = "Illegal input"
      end
    elsif params[:mode] == "delete"
      if params[:match_id] =~ /^[0-9]{8}$/
        @mode = "delete"
        match = Match.find_by_id(params[:match_id])
        if !match.nil?
          match_count = Match.where(:trip_id => match.trip_id).count
          user = User.find_by_id(match.user_id)
          trip = Trip.find_by_id(match.trip_id)
          if match_count == 1
            trip.locked = true
            trip.save(:validate => false)
          end
          UserMailer.booking_cancellation(user, trip, match, Origin.find_by_id_cached(trip.origin_id)).deliver
          match.delete
        else
          @error = "Match not found"
        end
      else
        @error = "Illegal input"
      end
    elsif params[:mode] == "update"
    elsif params[:mode] == "script"
      @trip = Trip.find_by_id(params[:trip_id])
      if !@trip.nil?
        @mode = "script"
        matches = Match.includes(:user).where(:trip_id => params[:trip_id]).order("matches.time_created ASC")
        @leader = matches.first.user
        @count = matches.size
        locations = [0, 6547, 6550, 11219, 11231]
        @origin = locations[@trip.origin_id] + @trip.airport_id
        if @trip.airport_id == 1
          @time = @trip.time + 60*(60*3 + 10)
        else
          @time = @trip.time + 60*(60*2.5 + 10)
        end
        @hour = @time.hour % 12
        if @hour == 0
          @hour = 12
        end
        @meridiem = (@time.hour > 11) ? "PM" : "AM"
      else
        @error = "Could not find trip with id #{params[:trip_id]}"
      end
    end
    respond_to do |format|
      format.js
    end
  rescue Exception => e
    @error = e.message
    respond_to do |format|
      format.js
    end
  end
end
