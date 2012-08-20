class UsersController < ApplicationController

  #require securerandom
 
  before_filter :require_login, :only => [:show] 
  before_filter :require_logout, :only => [:new, :create] 
 
  def new
  end  

  def create
    user = User.new(params[:user])
    user.email = user.email.downcase
    user.confirmed = false
    user.password_salt = SecureRandom.hex 
    user.one_time_password = SecureRandom.hex
    begin
      user.account_id = SecureRandom.random_number(90000000) + 10000000
    end while User.find_by_account_id(user.account_id) != nil
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
    if !user.confirmed && params[:user][:password]  
      if user.one_time_password == params[:user][:temporary_password]
        user.password = params[:user][:password]
        user.password_confirmation = params[:user][:password_confirmation]
        user.confirmed = true
        user.one_time_password = SecureRandom.hex
        if user.save
          flash[:notice] = "Password created! Try logging in!"
          redirect_to root_url  
        else
          flash[:error] = user.errors.full_messages.to_sentence
          redirect_to root_url
        end
      else 
        flash[:error] = "Incorrect temporary password."
        redirect_to root_url
      end
    else
    end
  end
end
