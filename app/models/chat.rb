class Chat < ActiveRecord::Base
	belongs_to :user
	belongs_to :chatable, polymorphic: true
	validates :message, presence: true,
                    length: { minimum: 1 }
    has_one :chat_resource

    def self.get_by_params(params)
    	res = self.all
        if (params[:after_id]) 
            res = res.where("id > ?", params[:after_id]) unless params[:after_id].nil?
            res = res.order(id: :asc)
        elsif (params[:before_id])
            res = res.where("id < ?", params[:before_id]) unless params[:before_id].nil?
            res = res.order(id: :desc)
    	else
            res = res.order(id: :desc);
        end
        if (params[:limit]) 
            res = res.limit(params[:limit])
        end
        res.sort_by( &:id)
    end

    def resource_download_url
        self.chat_resource.avatar.expiring_url(10) rescue nil
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
                },
                :chat_resource => {
                    :only => [:avatar_content_type, :avatar_file_name],
                    :methods => [:private_resource_url] 
                }
            }
        }
    end
end
