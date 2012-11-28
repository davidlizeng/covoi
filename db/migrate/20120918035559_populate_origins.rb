class PopulateOrigins < ActiveRecord::Migration
  def up
    wl = Origin.new
    wl.name = "Kimball Hall"
    wl.address = "673 Escondido Rd"
    wl.city = "Stanford"
    wl.state = "CA"
    wl.zip = "94305"
    wl.save

    ta = Origin.new
    ta.name = "Escondido Turnaround"
    ta.address = "618 Escondido Rd"
    ta.city = "Stanford"
    ta.state = "CA"
    ta.zip = "94305"
    ta.save

    tr = Origin.new
    tr.name = "Tresidder Union"
    tr.address = "459 Lagunita Dr"
    tr.city = "Stanford"
    tr.state = "CA"
    tr.zip = "94305"
    tr.save

    rg = Origin.new
    rg.name = "Roble Gym"
    rg.address = "351 Santa Teresa St"
    rg.city = "Stanford"
    rg.state = "CA"
    rg.zip = "94305"
    rg.save

    gc = Origin.new
    gc.name = "Governor's Corner"
    gc.address = "236 Santa Teresa St"
    gc.city = "Stanford"
    gc.state = "CA"
    gc.zip = "94305"
    gc.save
  end

  def down
    Origin.destroy_all
  end
end
