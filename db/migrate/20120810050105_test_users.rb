class TestUsers < ActiveRecord::Migration
  def up
   #down
   # dz = User.new(
   #     :first_name => "David", 
   #     :last_name => "Zeng",
   #     :email => "dzeng0@stanford.edu",
   #     :account_id => 0,
   #     :password_digest => "hello",
   #     :password_salt => "bla")
   # dz.save(:validate => false)
  end

  def down
    #User.delete_all
  end
end
