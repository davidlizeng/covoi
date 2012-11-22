module UsersHelper

  def valid_token?(id, token, user)
    return Digest::SHA2.hexdigest(id.to_s + user.password_salt + user.one_time_password) == token
  end
end
