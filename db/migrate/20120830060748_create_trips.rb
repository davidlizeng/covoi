class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips, {:id => false} do |t|
      t.integer :id, :limit => 8
      #t.datetime :trip_time
      t.integer :origin, :limit => 2
      t.integer :destination, :limit => 2 
      #t.integer :airline, :limit => 2
      #t.timestamp :time_created
    end
    execute "ALTER TABLE trips ADD PRIMARY KEY (id);"
  end
end
