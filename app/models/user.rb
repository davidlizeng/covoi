class User < ActiveRecord::Base
  attr_accessor :password, :password_confirmation, :email_confirmation
  has_many :matches
  has_many :trips, :through => :matches
  #self.primary_key = :id
  set_primary_key :id
  validate :validate_on_create, :on => :create
  validate :validate_on_update, :on => :update

  def authenticate(entered_password)
    return self.password_digest == Digest::SHA2.hexdigest(entered_password + self.password_salt)
  end

  def validate_on_create
    errors.add(:email, "must be a valid SUNetID Email") unless email =~ /^[a-z0-9]{3,8}@stanford\.edu$/
    errors.add(:email, "is already registered") unless User.find_by_email(email) == nil
    errors.add(:email, "does not match Email Confirmation") unless email.eql? email_confirmation
    errors.add(:first_name, "must be between 1 and 15 characters") unless first_name.length >= 1 && first_name.length <= 15
    errors.add(:last_name, "must be between 1 and 15 characters") unless last_name.length >= 1 && last_name.length <= 15
    errors.add(:phone, "must be 10 digits with no other characters") unless phone.to_s =~ /^[0-9]{10}$/
    errors.add(:password, "must be between 6 and 31 characters") unless password.length >= 6 && password.length <= 31
    errors.add(:password, "does not match Password Confirmation") unless password.eql? password_confirmation
  end

  def validate_on_update
    errors.add(:first_name, "must be between 1 and 15 characters") unless first_name.length >= 1 && first_name.length <= 15
    errors.add(:last_name, "must be between 1 and 15 characters") unless last_name.length >= 1 && last_name.length <= 15
    errors.add(:phone, "must be 10 digits with no other characters") unless phone.to_s =~ /^[0-9]{10}$/
    if !password.empty?
      errors.add(:password, "must be between 6 and 31 characters") unless password.length >= 6 && password.length <= 31
      errors.add(:password, "does not match Password Confirmation") unless password.eql? password_confirmation
    end
  end
end
