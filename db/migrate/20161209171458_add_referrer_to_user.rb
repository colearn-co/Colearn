class AddReferrerToUser < ActiveRecord::Migration
  def change
  	add_column :users, :referrer, :string
  end
end
