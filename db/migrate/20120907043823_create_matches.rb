class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches, {:id => false} do |t|
      t.integer :id
      t.integer :user_id
      t.integer :trip_id
      t.integer :group_id
      t.timestamp :time_created
    end
    execute "ALTER TABLE matches ADD PRIMARY KEY (id);"
  end
end
