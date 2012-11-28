class AdminsController < ApplicationController

  before_filter :require_admin

  def show
    @user = current_user
    @origins = Origin.find_all_cached
    @airports = Airport.find_all_cached
    @matches = Match.includes(:trip, :user).order("trips.time ASC, trips.id ASC, matches.time_created ASC")
  end
end
