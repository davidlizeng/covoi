class AddTripsLock < ActiveRecord::Migration
  def up
    add_column :trips, :locked, :boolean
  end

  def down
    remove_column :trips, :locked
  end
end
