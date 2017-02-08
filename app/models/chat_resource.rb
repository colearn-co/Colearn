class ChatResource < ActiveRecord::Base
	has_attached_file :avatar,
	                    :s3_credentials => "#{Rails.root}/config/s3.yml",
	                    :path => ":class/:attachment/:id_partition/:style/:filename",
      					:s3_permissions => :private
  	validates_attachment_size :avatar, :less_than => 10.megabytes
  	do_not_validate_attachment_file_type :avatar
  	belongs_to :chat

  	def private_resource_url
  		Rails.application.routes.url_helpers.resource_download_url_post_chat_path(self.chat.chatable, self.chat)
  	end
end
