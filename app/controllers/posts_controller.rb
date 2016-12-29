class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:new, :create, :close, :fetch_chat_info, :suggestion]
	load_and_authorize_resource
	
	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
		@post.skills.build
	end

	def fetch_chat_info
		@post = Post.find(params[:id])
		@post.user_visited_post_chat(current_user)
		@client_chats = ClientChat.all_client_chats(@post, params)
	end

	def create
		current_user.posts << @post = Post.new(post_params)
		redirect_to post_chats_path(@post)
	end

	def suggestion
		@post = Post.find(params[:id])
		@suggestion = Suggestion.new(suggestion_params)
		@suggestion.user = current_user
		@post.suggestions << @suggestion
	end

	def show
		@post = Post.find(params[:id])
	end

	def close
		@post = Post.find(params[:id])
		@post.mark_closed
		redirect_to post_path(@post)
	end


	private
	def post_params
		params.require(:post).permit(:title, :message, :skills_attributes => [:title])
	end
	def suggestion_params
		params.require(:suggestion).permit(:message)
	end
end
