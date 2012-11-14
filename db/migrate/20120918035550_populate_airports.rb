class PopulateAirports < ActiveRecord::Migration
  def up
    sfo = Airport.new
    sfo.code = "SFO"
    sfo.city = "San Francisco"
    sfo.state = "CA"
    sfo.save
    sjc = Airport.new
    sjc.code = "SJC"
    sjc.city = "San Jose"
    sjc.state = "CA"
    sjc.save
  end

  def down
    Airport.destroy_all
  end
end
