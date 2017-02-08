class AddTimeZoneToUser < ActiveRecord::Migration
  def change
  	add_column :users, :time_zone_offset, :integer
  end
end
