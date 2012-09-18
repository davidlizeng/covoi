class MatchesController < ApplicationController
  def new
  end 

  def create
    @trip = Trip.new(params[:trip])
    render "payments/new" 
  end

end
