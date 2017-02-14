class AddProjectToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :project_title, :text
  	add_column :posts, :project_desc, :text
  	add_column :posts, :project_oriented, :boolean
  end
end
