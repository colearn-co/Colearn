class AddVersionToDevice < ActiveRecord::Migration
  def change
  	add_column :device_tokens, :version, :string
  end
end
