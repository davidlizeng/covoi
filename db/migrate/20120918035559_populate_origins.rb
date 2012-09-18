class PopulateOrigins < ActiveRecord::Migration
  def up
    stern = Origin.new
    stern.name = "Stern Hall"
    stern.address = "1 Escondido Dr."
    stern.city = "Stanford"
    stern.state = "CA"
    stern.zip = "94309"
    stern.save
    wilbur = Origin.new
    wilbur.name = "Wilbur Hall"
    wilbur.address = "2 Escondido Dr."
    wilbur.city = "Stanford"
    wilbur.state = "CA"
    wilbur.zip = "94309"
    wilbur.save
    lag = Origin.new
    lag.name = "Lagunita Court"
    lag.address = "1 Santa Teresa Dr."
    lag.city = "Stanford"
    lag.state = "CA"
    lag.zip = "94309"
    lag.save
  end

  def down
    Origin.destroy_all
  end
end
