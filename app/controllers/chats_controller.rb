class ChatsController < ApplicationController
	# TODO: check why this is needed?
	skip_before_filter  :verify_authenticity_token
	
	def index
		@chatable = find_chatable
		@chats = @chatable.chats.get_by_params(params)
		render :json => @chats
		#render "/#{@chatable.class.name.underscore}s/chats/index"
	end
	def new
		@chatable = find_chatable
		@chat = Chat.new :chatable=>@chatable
		render "/#{@chatable.class.name.underscore}s/chats/new"
	end

	def create
		@chatable = find_chatable
		@chat= Chat.new(chat_params)
  		@chat.user = current_user

  		@chatable.chats.push(@chat)# @chatable.chats << @chat= Chat.new(chat_params)
  		@chat.save!
  		render :json => "done"
	end
private
	def find_chatable
		params.each do |name, value|
			if name =~ /(.+)_id$/
			return $1.classify.constantize.find(value)
			end
		end
		nil
	end
	def chat_params
      params.require(:chat).permit(:message)
    end
end