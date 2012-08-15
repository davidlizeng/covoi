module UsersHelper

  def valid_otp?(id, otp)
    user = User.find_by_account_id(id)
    return user.one_time_password == otp  
  end 
end
