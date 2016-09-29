class PostsController < ApplicationController
	before_filter :authenticate_user!, :only => [:new, :create]
	
	def index
		@posts = Post.all
	end

	def new
		@post = Post.new
	end

	def create
		current_user.posts << @post = Post.create!(post_params)
		redirect_to posts_path
	end

	def show
		@post = Post.find(params[:id])
	end


	private
	def post_params
		params.require(:post).permit(:message)
	end
end
