class Trip < ActiveRecord::Base
  attr_accessible :id, :origin, :destination
  has_many :users, :through => :matches 
  set_primary_key :id 

  attr_accessor :card_token
end
