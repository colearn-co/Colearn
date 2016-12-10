class AddStatusToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :status, :integer
  	Post.all.update_all(:status => Post::STATUS[:open])
  end
end
