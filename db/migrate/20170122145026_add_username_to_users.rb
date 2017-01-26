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
      if !user.name? || !validate_name_allowed_chars?(user.name)
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
  def validate_name_allowed_chars? str
    chars = Set.new(('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ["."])
    str.chars.detect {|ch| !chars.include?(ch)}.nil?
  end
end
