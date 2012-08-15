class SessionsController < ApplicationController
  before_filter :require_login, :only => [:destroy]
  before_filter :require_logout, :only => [:new, :create]  

  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.confirmed && user.authenticate(params[:session][:password])
      login(user)
      redirect_to user#users_path(user.account_id)
    else
      flash[:error] = "Wrong email/pw combo"
      redirect_to root_url
    end
  end

  def destroy
    logout
    redirect_to root_url    
  end
end
