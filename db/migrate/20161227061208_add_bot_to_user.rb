class AddBotToUser < ActiveRecord::Migration
  def change
  	usr = User.new(:email => User::BOT[:email], :name => "Colearn-Bot", :password => Devise.friendly_token[0..10])
  	usr.skip_confirmation!
  	usr.save!
  end
end
