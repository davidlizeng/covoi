class CreateTrips < ActiveRecord::Migration
  def change
    #create_table :trips, {:primary_key => :id} do |t|
    create_table :trips, {:id => false} do |t|
      t.integer :id
      t.integer :creator_id
      t.datetime :time
      t.integer :origin_id, :limit => 2
      t.integer :airport_id, :limit => 2
      t.timestamp :time_created
    end
    #if Rails.env != "development" then
      execute "ALTER TABLE trips ADD PRIMARY KEY (id);"
      execute "CREATE UNIQUE INDEX ON trips(id);"
    #end
  end
end
