class CommentsController < ApplicationController
	before_filter :authenticate_user!, :only => [:create]

	def index
		@commentable = find_commentable
		@comments = @commentable.comments.order(created_at: :desc).paginate(:page => params[:page] || 1, :per_page => 10)
  		render "/#{@commentable.class.name.underscore}s/comments/index".downcase
	end

	def create
		@commentable = find_commentable
  		@comment = @commentable.comments.build(comment_params)
  		@comment.user = current_user
  		@comment.save
  		render "/#{@commentable.class.name.underscore}s/comments/response".downcase
	end


	private

	def find_commentable
		params.each do |name, value|
			if name =~ /(.+)_id$/
			return $1.classify.constantize.find(value)
			end
		end
		nil
	end

	def comment_params
      params.require(:comment).permit(:message)
    end
end
