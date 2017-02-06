class AddDisplayPicToUser < ActiveRecord::Migration
  def change
  	add_attachment :users, :display_pic
  end
end
