class AddMaxMembersToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :max_members, :integer
  	Post.update_all(:max_members => 20)
  end
end
