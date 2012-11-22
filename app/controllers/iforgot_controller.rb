class IforgotController < ApplicationController

  before_filter :require_logout
  before_filter :require_post, :only => [:new_post, :reset_post]

  def new
  end

  def new_post
    params[:user][:email] = params[:user][:email] || ""
    @user = User.find_by_email(params[:user][:email])
    if @user == nil || !@user.confirmed
      @error = "Invalid email"
    elsif @user.password_reset_active
      @error = "We've recently sent a reset password link to this email. Please email us at service@ridegrouped.com if you did not receive any emails for resetting your password."
    else
      @user.password_reset_active = true
      @user.save(:validate => false)
      UserMailer.password_reset(@user).deliver
    end
    respond_to do |format|
      format.js
    end
  end

  def reset
    @id = params[:user_id] || 0
    @token = params[:auth_token] || ""
    @user = User.find_by_id(@id)
    if @user == nil || !@user.confirmed || !valid_token?(@id, @token, @user)
      @error = "Invalid password reset link"
    end
  end

  def reset_post
    @id = params[:id] || 0
    @token = params[:token] || ""
    params[:user][:password] = params[:user][:password] || ""
    params[:user][:password_confirmation] = params[:user][:password_confirmation] || ""
    @user = User.find_by_id(@id)
    if @user == nil || !@user.confirmed || !valid_token?(@id, @token, @user)
      @error = "Invalid password reset link"
    else
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.valid?
        @user.password_salt = SecureRandom.hex
        @user.one_time_password = SecureRandom.hex
        @user.password_digest= Digest::SHA2.hexdigest(@user.password + @user.password_salt)
        @user.password_reset_active = false
        @user.save
        flash[:notice] = "Password succesfully reset. Try logging in!"
      else
        @error = @user.errors.full_messages[0]
      end
    end
    respond_to do |format|
      format.js
    end
  end
end
