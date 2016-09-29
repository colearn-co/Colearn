class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
    	t.text :message
    	t.belongs_to :user

      t.timestamps null: false
    end
  end
end
