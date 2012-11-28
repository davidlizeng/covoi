class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches, {:id => false} do |t|
      t.integer :id, :limit => 8
      t.integer :user_id, :limit => 8
      t.integer :trip_id, :limit => 8
      t.integer :group_id
      t.timestamp :time_created
    end
    execute "ALTER TABLE matches ADD PRIMARY KEY (id);"
  end
end
