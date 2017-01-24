class AddUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :username, :string
    add_index :users, :username, unique: true
    addUsernames
  end

  def addUsernames
  	users = User.all;
    usernameSet = Set.new
  	users.each do |user|
      if !user.name?
        user.username = Haikunator.haikunate(9999, '.')
      elsif !usernameSet.include?(user.name.split(" ")[0].downcase)
  		  user.username = user.name.split(" ")[0].downcase
  	  else
        user.username = user.name.split(" ")[0].downcase + rand(1000).to_s
      end
      usernameSet.add(user.username)
      puts user
      user.save!
    end
  end
end
