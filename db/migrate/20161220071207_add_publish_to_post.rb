class AddPublishToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :publish_status, :integer, :index => true
  	Post.unscoped.update_all(:publish_status => Post::PUBLISH_STATUS[:published])
  end
end
