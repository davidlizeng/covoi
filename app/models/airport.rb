class Airport < ActiveRecord::Base
  attr_accessible :id, :code, :city, :state, :terminal

  @@cache = [
    { :id => 1,
      :code => "SFO", 
      :city => "San Francisco", 
      :state => "CA",
      :terminal => "Domestic" },
    { :id => 2,
      :code => "SFO",
      :city => "San Francisco",
      :state => "CA",
      :terminal => "International" },
    { :id => 3,
      :code => "SJC",
      :city => "San Jose",
      :state => "CA",
      :terminal => "" }
  ]
  
  def self.find_by_id_cached(id)
    Airport.new(@@cache[id - 1])
  end

  def self.find_all_cached
    airports = []
    @@cache.each do |airport|
      airports.push(Airport.new(airport))
    end
    return airports
  end

end
