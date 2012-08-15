class User < ActiveRecord::Base
  attr_accessible :last_name, :first_name, :email, :account_id, :password_digest, :password_salt, :confirmed, :one_time_password
  
  def authenticate(entered_password)
    return self.password_digest == Digest::SHA1.hexdigest(entered_password + self.password_salt)
  end

  def password=(entered_password)
    self.password_salt = SecureRandom.hex
    self.password_digest = Digest::SHA1.hexdigest(entered_password + self.password_salt)
  end
  
end
