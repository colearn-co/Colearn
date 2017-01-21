class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
    	t.string :title, index: true, unique: true


      t.timestamps null: false
    end
    
    create_table :tags_topics, id: false do |t|
      t.belongs_to :topic, index: true
      t.belongs_to :tag, index: true
    end
  end
end
