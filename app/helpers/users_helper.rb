module UsersHelper

  def valid_token?(id, token, user)
    return Digest::SHA2.hexdigest(id.to_s + user.password_salt + user.one_time_password) == token
  end

  def require_post
    if !request.post?
      flash[:error] = {:id => "message_banner", :message => "Page Not Found"}
      redirect_to root_url
    end
  end

  def require_admin
    unless logged_in? && current_user.admin
      redirect_to root_url
    end
  end
end
