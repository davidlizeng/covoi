class IndexMatches < ActiveRecord::Migration
  def up
    execute "CREATE INDEX ON matches(trip_id);"
    execute "CREATE INDEX ON matches(user_id);"
  end

  def down
  end
end
