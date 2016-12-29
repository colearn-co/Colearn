class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
    	t.string :name

      t.timestamps null: false
    end
    create_table :roles_users, id: false do |t|
      t.belongs_to :role, index: true
      t.belongs_to :user, index: true
    end
    role = Role.create(:name => 'admin')
    usr = User.where(:email => "colearn.xyz@gmail.com").first
    usr.roles = [role] if usr
  end
end
