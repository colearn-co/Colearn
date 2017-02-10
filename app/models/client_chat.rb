class ClientChat
	attr_accessor :members, :chats

	def initialize(args)
		args.each do |key, value|
			instance_variable_set("@#{key}", value)
		end
	end

	def self.all_client_chats(post, params)
		chats = post.chats.get_by_params(params)
		members = post.members
		ClientChat.new(:members => members + [User.colearn_bot], :chats => chats)
	end

	def client_chats_json(post)
		{
			:members => members.map{|v| v.json_info(post)},
			:past_members => post.past_members.map{|v| v.json_info(post)},
			:chats => chats.as_json(Chat.json_info)
		}
	end
end