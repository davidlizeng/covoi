class PopulateRides < ActiveRecord::Migration
  def up
    #SJC 12/15
    t = Trip.new
    t.id = 583935313
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 2
    t.time = Time.new(2012, 12, 15, 6, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 116507289
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 2
    t.time = Time.new(2012, 12, 15, 9, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 651041186
    t.creator_id = 0
    t.origin_id = 2
    t.airport_id = 2
    t.time = Time.new(2012, 12, 15, 11, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    #SFO 12/13
    t = Trip.new
    t.id = 241647080
    t.creator_id = 0
    t.origin_id = 2
    t.airport_id = 1
    t.time = Time.new(2012, 12, 13, 5, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 923983171
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 13, 7, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 404530262
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 13, 9, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 418242409
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 13, 19, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    #SFO 12/14
    t = Trip.new
    t.id = 180886685
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 14, 12, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 703174106
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 14, 17, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 780014393
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 14, 19, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    #SFO 12/15
    t = Trip.new
    t.id = 184050002
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 15, 5, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 305524649
    t.creator_id = 0
    t.origin_id = 2
    t.airport_id = 1
    t.time = Time.new(2012, 12, 15, 7, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 646765797
    t.creator_id = 0
    t.origin_id = 2
    t.airport_id = 1
    t.time = Time.new(2012, 12, 15, 8, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 168383897
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 15, 10, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save

    t = Trip.new
    t.id = 887325943
    t.creator_id = 0
    t.origin_id = 1
    t.airport_id = 1
    t.time = Time.new(2012, 12, 15, 12, 0, 0, "-08:00")
    t.time_created = Time.now
    t.save
  end

  def down
    Trip.delete_all("creator_id = 0")
  end
end
