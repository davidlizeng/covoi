module UsersHelper

  def valid_token?(id, token)
    user = User.find_by_account_id(id)
    return user && !user.confirmed && Digest::SHA1.hexdigest(id.to_s + user.password_salt) == token  
  end 
end
