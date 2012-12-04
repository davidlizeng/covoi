class AdminsController < ApplicationController

  before_filter :require_admin

  def show
    @user = current_user
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
    @matches = Match.includes(:trip, :user).order("trips.time ASC, trips.id ASC, matches.time_created ASC")
    @unconfirmed = User.all(:conditions => {:confirmed => false})
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
