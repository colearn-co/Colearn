class Chat < ActiveRecord::Base
	belongs_to :user
	belongs_to :chatable, polymorphic: true
	validates :message, presence: true,
                    length: { minimum: 1 }

    def self.get_by_params(params)
    	res = self.all

        res = res.where("id > ?", params[:after_id]) unless params[:after_id].nil?
    	res = res.where("id < ?", params[:before_id]) unless params[:before_id].nil?
    	res = res.order(id: :ASC)
        res = res.limit(params[:limit] || 20)
    	res
    end

    def username
    	self.user.try(:name)
    end

    def self.json_info
        {
            :only => [:id, :message, :created_at],
            :include => {
                :user => {
                    :only => [:id]
                }
            }
        }
    end
end
