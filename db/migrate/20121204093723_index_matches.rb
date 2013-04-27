class IndexMatches < ActiveRecord::Migration
  def up
    if Rails.env != "development" then
      execute "CREATE INDEX ON matches(trip_id);"
      execute "CREATE INDEX ON matches(user_id);"
    end
  end

  def down
  end
end
