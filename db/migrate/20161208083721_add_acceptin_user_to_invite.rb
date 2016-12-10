class AddAcceptinUserToInvite < ActiveRecord::Migration
  def change
  	add_column :invites, :accepting_user_id, :integer
  end
end
