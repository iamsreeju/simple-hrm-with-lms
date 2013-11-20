class AddFieldsToAdvance < ActiveRecord::Migration
  def change
  		add_column :advances, :status, :string, :default => "open"
  end
end
