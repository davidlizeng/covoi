class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches, {:primary_key => :id} do |t|
      t.integer :id
      t.integer :user_id
      t.integer :trip_id
      t.integer :group_id
      t.timestamp :time_created
    end
    if Rails.env != "development" then
      execute "ALTER TABLE matches ADD PRIMARY KEY (id);"
      execute "CREATE UNIQUE INDEX ON matches(id);"
    end
  end
end
