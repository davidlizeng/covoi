class SessionsController < ApplicationController
  before_filter :require_login, :only => [:destroy]
  before_filter :require_logout, :only => [:new, :create]  

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.confirmed && user.authenticate(params[:session][:password])
      login(user)
      flash[:notice] = "You have logged in."
      redirect_to user_path(user.account_id)
    else
      flash[:error] = "Wrong email or password"
      redirect_to root_url
    end
  end

  def destroy
    logout
    flash[:notice] = "You have logged out."
    redirect_to root_url    
  end
end
