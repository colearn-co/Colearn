class AddRejectMessageToInvite < ActiveRecord::Migration
  def change
  	add_column :invites, :reject_message, :text
  end
end
