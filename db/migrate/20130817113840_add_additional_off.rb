class AddAdditionalOff < ActiveRecord::Migration
  def change
  	add_column :leave_types, :forwarded_off, :boolean, :default => false
  end
end
