class CreateChatResources < ActiveRecord::Migration
  def change
    create_table :chat_resources do |t|
    	t.attachment :avatar
    	t.belongs_to :chat


      t.timestamps null: false
    end
  end
end
