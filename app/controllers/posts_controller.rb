class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:new, :create, :close]
	load_and_authorize_resource
	
	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
		@post.skills.build
	end

	def create
		puts post_params
		current_user.posts << @post = Post.new(post_params)
		redirect_to root_path
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
end
