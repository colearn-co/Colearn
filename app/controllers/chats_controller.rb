class ChatsController < ApplicationController
	# TODO: check why this is needed?
	before_filter :authenticate_user!, :only => [:new, :create, :resource_download_url]
	skip_before_filter  :verify_authenticity_token
	load_and_authorize_resource :only => [:resource_download_url]
	layout "chat_layout"

	def index
		@chatable = find_chatable
		@chats = @chatable.chats.get_by_params(params)

		#render :json => @chats.as_json(:methods => [:username])
		render "/#{@chatable.class.name.underscore}s/chats/index"
	end

	def new
		@chatable = find_chatable
		@chat = Chat.new :chatable=>@chatable
		render "/#{@chatable.class.name.underscore}s/chats/new"
	end

	def resource_download_url
		@chat = Chat.find(params[:id])
		redirect_to @chat.resource_download_url
	end

	def create
		@chatable = find_chatable

		if @chatable.chatting_allowed?(current_user)
			@chat = @chatable.create_user_chat(current_user, chat_params)
	  		render :json => {:chat => @chat.as_json(Chat.json_info)}
	  	end

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