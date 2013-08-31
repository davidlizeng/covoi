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
    @before = Time.new(2013, 12, 1, 0, 0, 0, "-07:00")
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
    puts @matches.size
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

  def sort
    show()

    @to_sort = nil
    @filter = ""
    @property = ""
    @sorting = ""
    if !params[:sort_all].nil? then
      @property = params[:sort_all][:select]
      @filter = params[:sort_all][:input].downcase
      @to_sort = @matches
      @sorting = "all"
    elsif !params[:sort_solo].nil? then
      @property = params[:sort_solo][:select]
      @filter = params[:sort_solo][:input].downcase
      @to_sort = @solo
      @sorting = "solo"
    elsif !params[:sort_grouped].nil? then
      @property = params[:sort_grouped][:select]
      @filter = params[:sort_grouped][:input].downcase
      @to_sort = @groups
      @sorting = "grouped"
    end

    if !@filter.nil? && @filter != "" then
      to_delete = []
      for i in 0..@to_sort.length-1
        keep = false
        matches = []
        if @sorting == "grouped" then
          @to_sort[i].each do |match|
            matches.push(match)
          end
        else
          matches.push(@to_sort[i])
        end
        matches.each do |match|
          name = match.user.first_name + " " + match.user.last_name
          if match.id.to_s.downcase.include?(@filter) ||
              Origin.find_by_id(match.trip.origin_id).name.downcase.include?(@filter) ||
              Airport.find_by_id(match.trip.airport_id).code.to_s.downcase.include?(@filter) ||
              match.trip.dateString.downcase.include?(@filter) ||
              match.trip.timeString.downcase.include?(@filter) ||
              name.downcase.include?(@filter) ||
              match.user.email.downcase.include?(@filter) ||
              match.user.phone.to_s.downcase.include?(@filter) then
            keep = true
            break
          end
        end
        if keep then next end
        to_delete.push(i)
        if @sorting == "grouped" then @grouped_count = @grouped_count - matches.length end
      end
      to_delete.reverse_each do |i|
        @to_sort.slice!(i)
      end
    end

    @to_sort.sort! { |x, y|
      if @sorting == "grouped" then
        x = x[0]
        y = y[0]
      end
  
      case @property
      when "ID"
        x.id <=> y.id
      when "Trip ID"
        x.trip.id <=> y.trip.id
      when "Origin"
        Origin.find_by_id(x.trip.origin_id).name <=> Origin.find_by_id(y.trip.origin_id).name
      when "Destination"
        Airport.find_by_id(x.trip.airport_id).code <=> Airport.find_by_id(y.trip.airport_id).code
      when "Date"
        x.trip.dateString <=> y.trip.dateString
      when "Time"
        x.trip.timeString <=> y.trip.timeString
      when "First Name"
        x.user.first_name <=> y.user.first_name
      when "Last Name"
        x.user.last_name <=> y.user.last_name
      when "Creator First Name"
        User.find_by_id(x.trip.creator_id).first_name <=> User.find_by_id(y.trip.creator_id).first_name
      when "Creator Last Name"
        User.find_by_id(x.trip.creator_id).last_name <=> User.find_by_id(y.trip.creator_id).last_name
      when "Email"
        x.user.email <=> y.user.email
      when "Phone"
        x.user.phone <=> y.user.phone
      when "Creator Email"
        User.find_by_id(x.trip.creator_id).email <=> User.find_by_id(y.trip.creator_id).email
      when "Creator Phone"
        User.find_by_id(x.trip.creator_id).phone <=> User.find_by_id(y.trip.creator_id).phone
      end
    }
    render :action => "show"
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
