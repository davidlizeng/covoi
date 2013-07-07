class SessionsController < ApplicationController

  before_filter :require_login, :only => [:destroy]
  before_filter :require_logout, :only => [:new, :create]

  def new
  end

  def create
    @user = User.find_by_email(params[:session][:email].downcase)
    respond_to do |format|
      if @user && @user.confirmed && @user.authenticate(params[:session][:password])
        login(@user)
      else
        @error = "Wrong email or password"
      end
      format.js
    end
  end

  def destroy
    logout
    redirect_to root_url
  end
end
