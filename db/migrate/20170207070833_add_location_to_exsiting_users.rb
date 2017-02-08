class AddLocationToExsitingUsers < ActiveRecord::Migration
  def change
  	User.all.each do |usr|
  		puts "Adding profile for user #{usr.username}"
  		usr.create_basic_user_profile
  	end
  end
end
