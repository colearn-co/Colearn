class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:close, :fetch_chat_info, :suggestion, :edit, :update, :my_participation]
	load_and_authorize_resource
	
	def index
		@posts = Post.all
	end

	def my_participation
		@posts = current_user.participated_posts
	end

	def search
		@posts = Post.search(params)
		render :json => @posts.as_json(:only => [:title], :methods => [:to_param])
	end

	def edit
		@post = Post.find(params[:id])
	end

	def update
		@post = Post.find(params[:id])
		@post.update_attributes(post_params)
		redirect_to post_path(@post)
	end

	def new
		@udacity = Udacity.find_by(id: params[:udacity])
		if $redis.get(dummy_post_key)
			@post = Post.new(JSON.parse($redis.get(dummy_post_key)))
			$redis.del(dummy_post_key)
		elsif @udacity
			@post.udacity = @udacity
			@post.title = @udacity.title + " on Udacity"
			@post.message = "Looking for someone to learn [" + @udacity.title + "] (" + @udacity.homepage + ")" + " course on Udacity."				
		else
			@post = Post.new(:title => params[:title])
			@post.project_oriented = true
		end
		@post.skills.build if @post.skills.blank?
	end

	def fetch_chat_info
		@post = Post.find(params[:id])
		@post.user_visited_post_chat(current_user)
		@client_chats = ClientChat.all_client_chats(@post, params)
	end

	def create
		if current_user
			current_user.posts << @post = Post.new(post_params)
			redirect_to post_chats_path(@post)			
		else
			$redis.set(dummy_post_key, post_params.to_json)
			$redis.expire(dummy_post_key, 60 * 60)
			store_location_for(:user, new_post_url)
			authenticate_user!
		end		
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
		params.require(:post).permit(:title, :message, :max_members, :project_oriented, :project_title, :project_desc, :udacity_id, :skills_attributes => [:title, :id])
	end
	def suggestion_params
		params.require(:suggestion).permit(:message)
	end
end
