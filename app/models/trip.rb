class Trip < ActiveRecord::Base
  attr_accessor :card_token
  has_many :users, :through => :matches
  has_one :origin
  has_one :airport 
  set_primary_key :id 
end
