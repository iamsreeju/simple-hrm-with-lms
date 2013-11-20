class ChangeLeaveDefaultDuration < ActiveRecord::Migration
  def change
  		change_column_default(:leave_requests, :full_day, true)
  end
end
