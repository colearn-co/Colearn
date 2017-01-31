class LeavePost < ActiveRecord::Migration
  def change
  	add_column :invites, :leave_message, :string
  	add_column :invites, :rejoin_message, :string
  end
end
