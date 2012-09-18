class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :user_id, :limit => 8
      t.integer :trip_id, :limit => 8
      t.boolean :is_creator
      t.timestamp :time_created
    end
  end
end
