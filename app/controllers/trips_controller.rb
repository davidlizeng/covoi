class TripsController < ApplicationController
  def new
  end

  def create
    @trip = Trip.new(params[:trip])
    render "matches/new"
  end
end
