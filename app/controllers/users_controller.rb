class UsersController < ApplicationController

  before_filter :require_login, :only => [:show, :edit, :update]
  before_filter :require_logout, :only => [:new, :create]

  def new
    params[:user_id] = params[:user_id] || 0
    params[:auth_token] = params[:auth_token] || ""
    @user = User.find_by_id(params[:user_id])
    if @user == nil || @user.confirmed || !valid_token?(params[:user_id], params[:auth_token], @user)
      flash[:error] = { :id => "message_banner", :message => "Invalid confirmation link" }
    else
      @user.stripe_customer_id = Stripe::Customer.create(
        :description => @user.id.to_s,
        :email => @user.email
      ).id
      @user.one_time_password = SecureRandom.hex
      @user.password_reset_active = false
      @user.confirmed = true
      @user.time_confirmed = Time.now
      @user.save(:validate => false)
      flash[:notice] = "Thank you for confirming your email. Try logging in with your new RideGrouped account!"
    end
    redirect_to root_url
  end

  def create
    params[:user][:email] = params[:user][:email] || ""
    params[:user][:email_confirmation] = params[:user][:email_confirmation] || ""
    @user = User.new
    @user.first_name = params[:user][:first_name] || ""
    @user.last_name = params[:user][:last_name] || ""
    @user.phone = params[:user][:phone] || ""
    @user.email = params[:user][:email].downcase
    @user.email_confirmation = params[:user][:email_confirmation].downcase
    @user.password = params[:user][:password] || ""
    @user.password_confirmation = params[:user][:password_confirmation] || ""
    respond_to do |format|
      if @user.valid?
        begin
          @user.id = SecureRandom.random_number(900000) + 100000
        end while User.find_by_id(@user.id) != nil
        @user.confirmed = false
        @user.one_time_password = SecureRandom.hex
        @user.password_salt = SecureRandom.hex
        @user.password_digest = Digest::SHA2.hexdigest(@user.password + @user.password_salt)
        @user.admin = false
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
      time_range = (Time.now - 60*60*24)..(Time.now + 60*60*24*30)
      @matches = Match.all(:include => :trip, :conditions => {:trips => { :time => time_range }, :user_id => @user.id}, :order => "trips.time ASC")
      @matches.each do |m|
        m["status"] = (Match.where(:trip_id => m.trip_id).count > 1) ? "Shared" : "Single"
      end
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
      @user.first_name = params[:user][:first_name] || ""
      @user.last_name = params[:user][:last_name] || ""
      @user.phone = params[:user][:phone] || ""
      @user.password = params[:user][:password] || ""
      @user.password_confirmation = params[:user][:password_confirmation] || ""
      if @user.valid?
        if !@user.password.empty?
          if @user.authenticate(params[:user_current_password])
            @user.password_salt = SecureRandom.hex
            @user.password_digest= Digest::SHA2.hexdigest(@user.password + @user.password_salt)
            @user.password_reset_active = false
          else
            @error = "You must enter your Current Password to change your password."
          end
        end
        @user.save
      else
        @error = @user.errors.full_messages[0]
      end
      format.js
    end
  end
  
  def myrides
    @user = current_user
  end
end
