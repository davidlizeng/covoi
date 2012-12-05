class MoveGroupId < ActiveRecord::Migration
  def up
    add_column :trips, :group_id, :integer
    remove_column :matches, :group_id
  end

  def down
    add_column :matches, :group_id, :integer
    remove_column :trips, :group_id
  end
end
