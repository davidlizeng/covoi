class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, {:id => false} do |t|
      t.integer :id, :limit => 8
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :password_digest
      t.string :password_salt
      t.boolean :confirmed
      t.timestamp :time_created
      t.timestamp :time_confirmed
      t.timestamp :last_login
    end
    execute "ALTER TABLE users ADD PRIMARY KEY (id);"
  end
end
