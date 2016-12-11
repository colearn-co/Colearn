class CreateUserChatInfos < ActiveRecord::Migration
  def change
    create_table :user_chat_infos do |t|
    	t.datetime :last_visited
    	t.belongs_to :user
    	t.belongs_to :post

      t.timestamps null: false
    end
    add_index :user_chat_infos, [:user_id, :post_id], :unique => true
  end
end
