class AddTagPostAssociation < ActiveRecord::Migration
  def change
	create_table :posts_tags, id: false do |t|
		t.belongs_to :post, index: true
		t.belongs_to :tag, index: true
    end
  end
end
