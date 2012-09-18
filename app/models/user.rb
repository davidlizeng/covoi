class User < ActiveRecord::Base
  attr_accessible :last_name, :first_name, :email, :id, :password_digest, :password_salt, :confirmed, :one_time_password
  has_many :trips, :through => :matches
  set_primary_key :id 
 
  def authenticate(entered_password)
    return self.password_digest == Digest::SHA2.hexdigest(entered_password + self.password_salt)
  end

  def password
    @password
  end 
 
  def password=(entered_password)
    @password = entered_password
    #self.password_salt = SecureRandom.hex
    self.password_digest = Digest::SHA2.hexdigest(entered_password + self.password_salt)
  end
 
  def password_confirmation
    @password_confirmation
  end
  
  def password_confirmation=(entered_password_confirmation)
    @password_confirmation = entered_password_confirmation
  end
 
  validates :first_name, :last_name, :email, :presence => true
  validates :first_name, :last_name, :length => {:in => 1..31}
  validates :email, :format => {:with => /^[a-z0-9]{3,8}@stanford\.edu$/,
      :message => "Invalid Stanford email format"}, :on => :create 
  validates :email, :uniqueness => true, :on => :create
  validates :password, :password_confirmation, :presence => true, :on => :update
  validates :password, :confirmation => true, :on => :update
  validates :password, :length => {:in => 6..31}, :on => :update 
 
end
