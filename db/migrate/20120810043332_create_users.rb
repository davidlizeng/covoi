class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users, {:primary_key => :account_id} do |t|
      t.column :first_name, :string
      t.column :last_name, :string
      t.column :email, :string
      t.column :account_id, :integer
      t.column :password_digest, :string
      t.column :password_salt, :string
      t.column :confirmed, :boolean
      t.column :one_time_password, :string
    end
  end
  
  def down
    drop_table :users
  end
end
