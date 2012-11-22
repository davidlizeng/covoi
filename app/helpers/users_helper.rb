module UsersHelper

  def valid_token?(id, token, user)
    return Digest::SHA2.hexdigest(id.to_s + user.password_salt + user.one_time_password) == token
  end

  def require_post
    if !request.post?
      flash[:error] = "Page Not Found"
      redirect_to root_url
    end
  end
end
