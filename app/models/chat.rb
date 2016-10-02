class Chat < ActiveRecord::Base
	belongs_to :user
	belongs_to :chatable, polymorphic: true
	validates :message, presence: true,
                    length: { minimum: 1 }

end
