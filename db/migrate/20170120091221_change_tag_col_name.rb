class ChangeTagColName < ActiveRecord::Migration
  def change
  	rename_column :tags, :tag, :title
  	remove_column :tags, :desc
  end
end
