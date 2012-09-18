class CreateAirports < ActiveRecord::Migration
  def change
    create_table :airports do |t|
      t.string :code
      t.string :city
      t.string :state
      t.string :terminal
    end
  end
end
