class AddShortSummToUdacity < ActiveRecord::Migration
  def change
  	add_column :udacities, :short_summary, :text
  end
end
