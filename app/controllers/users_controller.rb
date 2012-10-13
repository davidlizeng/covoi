class UsersController < ApplicationController

  before_filter :require_login, :only => [:show, :edit]
  before_filter :require_logout, :only => [:new, :create]

  def new
    if !valid_token?(params[:user_id], params[:auth_token])
      flash[:error] = "BADBADBAD"
      redirect_to root_url
    end
    @id = params[:user_id]
  end

  def create
    @user = User.new(params[:user])
    @user.email = @user.email.downcase
    @user.confirmed = false
    @user.password_salt = SecureRandom.hex
    @user.one_time_password = SecureRandom.hex
    begin
      @user.id = SecureRandom.random_number(900000000000) + 100000000000
    end while User.find_by_id(@user.id) != nil
    respond_to do |format|
      if @user.valid?
        UserMailer.registration_confirmation(@user).deliver
        @user.save
        format.html {redirect_to new_user_path}
        format.js
      else
        format.html {render "new"}
        format.js
      end
    end
  end

  def show
    @user = User.find_by_id(params[:id])
    @name = @user.first_name + " " + @user.last_name
  end

  def edit
  end

  def update
    user = User.find_by_id(params[:id])
    puts user.id
    if !user.confirmed && params[:user][:password]
      if user.one_time_password == params[:user][:temporary_password]
        user.password = params[:user][:password]
        user.password_confirmation = params[:user][:password_confirmation]
        user.confirmed = true
        user.one_time_password = SecureRandom.hex
        if user.save
          flash.now[:notice] = "Password created! Try logging in!"
          redirect_to root_url
        else
          flash.now[:error] = user.errors.full_messages.to_sentence
          redirect_to root_url
        end
      else
        flash.now[:error] = "Incorrect temporary password."
        redirect_to
      end
    else
    end
  end
end
