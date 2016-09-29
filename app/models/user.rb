class User < ActiveRecord::Base
	has_many :posts
	has_many :votes
	has_many :comments
	has_many :chats
	has_many :skills
 	
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 	:recoverable, :rememberable, :trackable, :validatable
end