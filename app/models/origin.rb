class Origin < ActiveRecord::Base
  attr_accessible :id, :name, :address, :city, :state, :zip

  @@cache = [
    { :id => 1,
      :name => "Wilbur Lot",
      :address => "673 Escondido Rd",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 2,
      :name => "Turnaround",
      :address => "618 Escondido Rd",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 3,
      :name => "Tresidder",
      :address => "459 Lagunita Dr",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
     { :id => 4,
      :name => "Roble Gym",
      :address => "351 Santa Teresa St",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 5,
      :name => "Gov Co",
      :address => "236 Santa Teresa St",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" }
   ]

  def self.find_by_id_cached(id)
    Origin.new(@@cache[id.to_i - 1])
  end

  def self.find_all_cached
    origins = []
    @@cache.each do |origin|
      origins.push(Origin.new(origin))
    end
    return origins
  end

  def self.buildOriginChoices(origins)
    origin_choices = []
    origins.each do |origin|
      origin_choices.push([origin.name, origin.id])
    end
    return origin_choices
  end
end
