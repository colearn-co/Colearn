class AddUserToInterest < ActiveRecord::Migration
  def change
  	create_table :interests_users, id: false do |t|
      t.belongs_to :interest, index: true
      t.belongs_to :user, index: true
    end
    add_index :interests, :title, :unique => true
  end
end
