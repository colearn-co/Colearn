class GenerateUsernames < ActiveRecord::Migration
  def change
  	addUsernames
  end
  def addUsernames
  	users = User.all;
  	users.each do |user|
      if !user.name? || !validate_name_allowed_chars?(user.name)
        user.username = Haikunator.haikunate(9999, '.')
      else
  		  user.username = user.name.split(" ")[0].downcase
  	  end
     
      puts user.inspect
      begin
      	user.save!
      rescue Exception => e
      	puts "Exception", e
      	user.username = Haikunator.haikunate(9999, '.')
      	user.save!
      end
      
    end
  end
  def validate_name_allowed_chars? str
    chars = Set.new(('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a + ["."])
    str.chars.detect {|ch| !chars.include?(ch)}.nil?
  end
end
