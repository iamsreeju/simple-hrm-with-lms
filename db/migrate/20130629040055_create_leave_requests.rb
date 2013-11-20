class CreateLeaveRequests < ActiveRecord::Migration
  def change
    create_table :leave_requests do |t|
      t.references :user
      t.references :leave_type
      t.integer :action_by
      t.date :leave_at
      t.boolean :full_day, :default => false
      t.string :reason
      t.string :status

      t.timestamps
    end
    add_index :leave_requests, :user_id
    add_index :leave_requests, :leave_type_id
  end
end
