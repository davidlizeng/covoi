class UsersController < ApplicationController

  before_filter :require_login, :only => [:show, :edit, :update]
  before_filter :require_logout, :only => [:new, :create]

  def new
    @user = User.find_by_id(params[:user_id])
    if @user == nil
      flash[:error] = "Invalid user id"
    elsif !@user.confirmed
      if !valid_token?(params[:user_id], params[:auth_token])
        flash[:error] = "Invalid authorization token"
      else
        Stripe::Customer.create(
          :description => @user.id.to_s,
          :email => @user.email
        )
        @user.confirmed = true
        @user.time_confirmed = Time.now
        @user.save(:validate => false)
        flash[:notice] = "Thank you for confirming your email!"
      end
    end
    redirect_to root_url
  end

  def create
    params[:user][:email] = params[:user][:email] || ""
    params[:user][:email_confirmation] = params[:user][:email_confirmation] || ""
    @user = User.new
    @user.first_name = params[:user][:first_name] || ""
    @user.last_name = params[:user][:last_name] || ""
    @user.email = params[:user][:email].downcase
    @user.email_confirmation = params[:user][:email_confirmation].downcase
    @user.password = params[:user][:password] || ""
    @user.password_confirmation = params[:user][:password_confirmation] || ""
    respond_to do |format|
      if @user.valid?
        begin
          @user.id = SecureRandom.random_number(900000000000) + 100000000000
        end while User.find_by_id(@user.id) != nil
        @user.confirmed = false
        @user.password_salt = SecureRandom.hex
        @user.password_digest = Digest::SHA2.hexdigest(@user.password + @user.password_salt)
        UserMailer.registration_confirmation(@user).deliver
        @user.time_created = Time.now
        @user.save
      end
      format.js
    end
  end

  def show
    if params[:id].eql?(current_user.id.to_s)
      @user = current_user
      @trips = @user.trips.where("time > (?)", Time.now - 60*60*24).order("time DESC").limit(2)
      @origins = Origin.find_all_cached
      @airports = Airport.find_all_cached
      @origin_choices = Origin.buildOriginChoices(@origins)
      @airport_choices = Airport.buildAirportChoices(@airports)
    else
      redirect_to user_path(current_user.id)
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    respond_to do |format|
      if @user.authenticate(params[:user_current_password])
        @user.first_name = params[:user][:first_name] || ""
        @user.last_name = params[:user][:last_name] || ""
        @user.password = params[:user][:password] || ""
        @user.password_confirmation = params[:user][:password_confirmation] || ""
        if @user.valid?
          if !@user.password.empty?
            @user.password_salt = SecureRandom.hex
            @user.password_digest= Digest::SHA2.hexdigest(@user.password + @user.password_salt)
          end
          @user.save
        end
      else
        @user.errors.add(:password, "is incorrect. Changes will not be submitted.")
      end
      format.js
    end
  end
end
