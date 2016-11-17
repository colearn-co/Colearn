class VotesController < ApplicationController
	before_filter :authenticate_user!, :only => [:create]

	

	def create
		@votable = find_votable
  		@vote = Vote.where(user: current_user, votable: @votable).first || votable.votes.build
  		@vote.vote_type = @vote.vote_type != params[:vote_type] && @vote.vote_type != Vote::TYPE[:none] ? Vote::TYPE[:none] : params[:vote_type]
  		@vote.user = current_user
  		@vote.save
  		render "/#{@votable.class.name.underscore}s/votes/response".downcase
	end


	private

	def find_votable
		params.each do |name, value|
			if name =~ /(.+)_id$/
			return $1.classify.constantize.find(value)
			end
		end
		nil
	end

end
