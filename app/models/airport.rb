class Airport < ActiveRecord::Base
  attr_accessible :id, :code, :city, :state, :terminal

  @@cache = [
    { :id => 1,
      :code => "SFO",
      :city => "San Francisco",
      :state => "CA"},
    { :id => 2,
      :code => "SJC",
      :city => "San Jose",
      :state => "CA"}
  ]

  def self.find_by_id_cached(id)
    Airport.new(@@cache[id.to_i - 1])
  end

  def self.find_all_cached
    airports = []
    @@cache.each do |airport|
      airports.push(Airport.new(airport))
    end
    return airports
  end

  def self.buildAirportChoices(airports)
    airport_choices = []
    airports.each do |airport|
      airport_choices.push([airport.city + " (" + airport.code + ")", airport.id])
    end
    return airport_choices
  end
end
