class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
    	t.text :message
    	t.belongs_to :user
    	t.belongs_to :post

      t.timestamps null: false
    end
  end
end
