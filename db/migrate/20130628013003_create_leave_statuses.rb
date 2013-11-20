class CreateLeaveStatuses < ActiveRecord::Migration
  def change
    create_table :leave_statuses do |t|
      t.references :user
      t.references :leave_type
      t.float :available, :default => 0

      t.timestamps
    end
    add_index :leave_statuses, :user_id
    add_index :leave_statuses, :leave_type_id
  end
end
