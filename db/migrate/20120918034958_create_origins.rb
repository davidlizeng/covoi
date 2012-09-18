class CreateOrigins < ActiveRecord::Migration
  def change
    create_table :origins do |t|
      t.string :name
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
    end
  end
end
