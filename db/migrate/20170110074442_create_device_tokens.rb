class CreateDeviceTokens < ActiveRecord::Migration
  def change
    create_table :device_tokens do |t|    	
    	t.string :token
    	t.boolean :valid_token, :default => true
    	t.belongs_to :user
      t.timestamps null: false
    end
    add_index :device_tokens, :token, :unique => true
  end
end
