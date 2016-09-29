class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
    	t.references :votable, polymorphic: true, index: true
    	t.belongs_to :user
    	t.integer :type

      t.timestamps null: false
    end
  end
end
