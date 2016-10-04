class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:new, :create]
	
	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
		@post.skills.build
	end

	def create
		puts post_params
		current_user.posts << @post = Post.create!(post_params)
		redirect_to posts_path
	end

	def show
		@post = Post.find(params[:id])
	end


	private
	def post_params
		params.require(:post).permit(:title, :message, :skills_attributes => [:title])
	end
end
