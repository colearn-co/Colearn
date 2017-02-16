class AddUdacityToPost < ActiveRecord::Migration
  def change
  	add_column :posts, :udacity_id, :integer
  end
end
