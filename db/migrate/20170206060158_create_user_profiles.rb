class CreateUserProfiles < ActiveRecord::Migration
  def change
    create_table :user_profiles do |t|
    	t.text :about_me
    	t.text :github
    	t.belongs_to :user

      t.timestamps null: false
    end
    add_index :user_profiles, :user_id, unique: true
  end
end
