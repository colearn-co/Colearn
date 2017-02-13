class Chat < ActiveRecord::Base
	belongs_to :user
	belongs_to :chatable, polymorphic: true
	validates :message, presence: true,
                    length: { minimum: 1 }
    has_one :chat_resource
    after_create :send_notifications

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
    	self.user.username
    end

    def self.json_info
        {
            :only => [:id, :message, :created_at, :src_device_id],
            :include => {
                :user => {
                    :only => [:id]
                },
                :chat_resource => {
                    :only => [:avatar_content_type, :avatar_file_name],
                    :methods => [:private_resource_url] 
                }
            },
            :methods => [:epoch_created_at]
        }
    end
    def epoch_created_at
        self.created_at.to_i * 1000
    end
    def notify_text
        "#{self.user.username}: #{self.message}"
    end

    def send_notifications
        begin
            PushNotification.send_post_chat_notifications(self)
        rescue => e
            ExceptionNotifier.notify_exception(e)
        end
    end

    def self.chat_params(params)
      params.require(:chat).permit(:message, :src_device_id)
    end
end
