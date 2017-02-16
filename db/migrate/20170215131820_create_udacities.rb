class CreateUdacities < ActiveRecord::Migration
  def change
    create_table :udacities do |t|
    	t.string :title
    	t.text :expected_learning
    	t.text :summary
    	t.string :level
    	t.string :image
    	t.string :homepage


      t.timestamps null: false
    end
  end
end
