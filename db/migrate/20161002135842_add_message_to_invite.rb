class AddMessageToInvite < ActiveRecord::Migration
  def change
  	add_column :invites, :message, :text
  end
end
