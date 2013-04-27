class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, {:id => false} do |t|
      t.integer :id
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :phone
      t.string :password_digest
      t.string :password_salt
      t.string :stripe_customer_id
      t.string :one_time_password
      t.boolean :confirmed
      t.boolean :password_reset_active
      t.boolean :admin
      t.timestamp :time_created
      t.timestamp :time_confirmed
    end
    if Rails.env != "development" then
      execute "ALTER TABLE users ADD PRIMARY KEY (id);"
      execute "CREATE UNIQUE INDEX ON users(id);"
      execute "CREATE UNIQUE INDEX ON users(email);"
    end
  end
end
