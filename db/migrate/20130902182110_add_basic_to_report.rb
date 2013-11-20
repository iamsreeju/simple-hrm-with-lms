class AddBasicToReport < ActiveRecord::Migration
  def change
  	add_column :report_lines, :report_basic, :decimal, :default => 0, :precision => 15, :scale => 5
  	add_column :report_lines, :report_deduct, :decimal, :default => 0, :precision => 15, :scale => 5
  end
end
