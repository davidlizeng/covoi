class UsersController < ApplicationController

  #require securerandom
 
  before_filter :require_login, :only => [:show] 
  before_filter :require_logout, :only => [:new, :create] 
 
  def new
  end  

  def create
    user = User.new(params[:user])
    user.confirmed = false
    begin
      user.account_id = SecureRandom.random_number(90000000) + 10000000
    end while User.find_by_account_id(user.account_id) != nil
    user.one_time_password = SecureRandom.hex
    if user.save
      UserMailer.registration_confirmation(user).deliver
      redirect_to root_url
    else
      redirect_to root_url
    end 
  end
 
  def show
    user = User.find_by_account_id(params[:id])
    @name = user.first_name + " " + user.last_name
  end
  
  def edit
  end

  def update
    user = User.find_by_account_id(params[:id])
    if params[:user][:password]
      user.password = params[:user][:password]
      user.confirmed = true
      user.one_time_password = SecureRandom.hex
      if user.save
        redirect_to root_url  
      else
        redirect_to root_url
      end
    else
    end
  end
end
