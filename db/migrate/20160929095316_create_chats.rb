class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
    	t.references :chatable, polymorphic: true, index: true
    	t.belongs_to :user
    	t.text :message

      t.timestamps null: false
    end
  end
end
