class Origin < ActiveRecord::Base
  attr_accessible :id, :name, :address, :city, :state, :zip

  @@valid_origins = ["1", "2", "4"]

  @@cache = [
    { :id => 1,
      :name => "Arrillaga Dining",
      :address => "618 Escondido Rd",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 2,
      :name => "Tresidder Union",
      :address => "459 Lagunita Dr",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 3,
      :name => "Roble Gym",
      :address => "351 Santa Teresa St",
      :city => "Stanford",
      :state => "CA",
      :zip => "94305" },
    { :id => 4,
      :name => "Governor's Corner",
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

  def self.isValidOrigin?(str)
    return @@valid_origins.include?(str)
  end
end
