class AddUserAndPostToSkill < ActiveRecord::Migration
  def change
  	add_column :skills, :post_id, :integer
  	add_column :skills, :user_id, :integer

  end
end
