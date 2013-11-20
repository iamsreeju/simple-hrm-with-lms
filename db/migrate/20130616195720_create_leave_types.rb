class CreateLeaveTypes < ActiveRecord::Migration
  def change
    create_table :leave_types do |t|
      t.string :leave_type_name
      t.integer :default_count, :default => 0 
      t.boolean :without_pay, :default => false
      t.boolean :month_forward, :default => false
      t.boolean :year_forward, :default => false
      t.timestamps
    end
  end
end
