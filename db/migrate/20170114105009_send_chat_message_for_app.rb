class SendChatMessageForApp < ActiveRecord::Migration
  def change
  	posts = Post.all;
  	posts.each do |post|
  		if post.members.count > 1
  			puts "Sending chat message for postid", post.id
  			post.create_user_chat(User.colearn_bot, 
  				ActionController::Parameters.new(chat: {:message => "Hello guys, Colearn has released a colearn notification app(Beta) for instant chat notification :smile:. 
  					Download now from https://play.google.com/store/apps/details?id=xyz.colearn.colearnnotification"}))
  		end
  	end
  end
end
