class Chat < ActiveRecord::Base
	belongs_to :user
	belongs_to :chatable, polymorphic: true
	validates :message, presence: true,
                    length: { minimum: 1 }

    def self.get_by_params(params)
    	res = self.all

    	res = res.where("id > ?", params[:id]) unless params[:id].nil?
    	res = res.joins(:user)
    	res = res.select("chats.*", "users.name as username")
    	res
    end
end
