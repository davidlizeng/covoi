class PopulateAirports < ActiveRecord::Migration
  def up
    sfoDom = Airport.new
    sfoDom.code = "SFO"
    sfoDom.city = "San Francisco"
    sfoDom.state = "CA"
    sfoDom.terminal = "Domestic"
    sfoDom.save
    sfoInt = Airport.new
    sfoInt.code = "SFO"
    sfoInt.city = "San Francisco"
    sfoInt.state = "CA"
    sfoInt.terminal = "International"
    sfoInt.save
    sjc = Airport.new
    sjc.code = "SJC"
    sjc.city = "San Jose"
    sjc.state = "CA"
    sjc.terminal = ""
    sjc.save
  end

  def down
    Airport.destroy_all
  end
end
