class PopulateOrigins < ActiveRecord::Migration
  def up
    wl = Origin.new
    wl.name = "Wilbur Lot"
    wl.address = "2 Escondido Dr."
    wl.city = "Stanford"
    wl.state = "CA"
    wl.zip = "94309"
    wl.save

    ta = Origin.new
    ta.name = "Turnaround"
    ta.address = "1 Escondido Dr."
    ta.city = "Stanford"
    ta.state = "CA"
    ta.zip = "94309"
    ta.save

    tr = Origin.new
    tr.name = "Tresidder"
    tr.address = "1 Lagunita Dr."
    tr.city = "Stanford"
    tr.state = "CA"
    tr.zip = "94309"
    tr.save

    rg = Origin.new
    rg.name = "Roble Gym"
    rg.address = "1 Santa Teresa St."
    rg.city = "Stanford"
    rg.state = "CA"
    rg.zip = "94309"
    rg.save

    gc = Origin.new
    gc.name = "Gov Co"
    gc.address = "2 Santa Teresa St."
    gc.city = "Stanford"
    gc.state = "CA"
    gc.zip = "94309"
    gc.save
  end

  def down
    Origin.destroy_all
  end
end
