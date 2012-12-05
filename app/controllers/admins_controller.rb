class AdminsController < ApplicationController

  before_filter :require_admin

  def show
    @user = current_user
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
    @matches = Match.includes(:trip, :user).order("trips.time ASC, trips.id ASC, matches.time_created ASC")
    @unconfirmed = []
    users = User.all(:conditions => {:confirmed => true}, :order => "id ASC")
    booked = User.joins(:matches).order("id ASC")
    @unbooked = []
    b = 0
    a = 0
    while a < booked.size
      while (a != (booked.size - 1)) && (booked[a].id == booked[a+1].id)
        a = a + 1
      end
      while booked[a].id.to_s != users[b].id.to_s
        @unbooked.push(users[b])
        puts booked[a].id.to_s + " " + users[b].id.to_s
        b = b + 1
      end
      b = b + 1
      a = a + 1
    end
    while b < users.size
      @unbooked.push(users[b])
      b = b + 1
    end
    @solo = []
    @groups = []
    @grouped_count = 0
    cur = []
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

  def create
    params[:trip_id] = params[:trip_id] || "0"
    params[:group_id] = params[:group_id] || "0"
    if params[:trip_id] =~ /^[0-9]{7}$/ && params[:group_id] =~ /^[0-9]{7}$/
      @trip = Trip.find_by_id(params[:trip_id])
      if !@trip.nil?
        @trip.group_id = params[:group_id]
        @trip.save(:validate => false)
        matches = Match.includes(:user).where(:trip_id => params[:trip_id]).order("matches.time_created ASC")
        emails = []
        matches.each do |m|
          emails.push(m.user.email)
        end
        email_string = emails.join(",")
        UserMailer.group_confirmation(email_string, matches, @trip, Origin.find_by_id_cached(@trip.origin_id)).deliver
      else
        @error = "Could not find trip"
      end
    else
      @error = "Illegal input"
    end
    respond_to do |format|
      format.js
    end
  end
end
