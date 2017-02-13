class AddDeviceIdToChat < ActiveRecord::Migration
  def change
    add_column :chats, :src_device_id, :string
  end
end
