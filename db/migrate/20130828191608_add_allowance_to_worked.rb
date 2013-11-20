class AddAllowanceToWorked < ActiveRecord::Migration
  def change
  	add_column :worked_holidays, :allowance_amount, :decimal, :default => 0, :precision => 15, :scale => 5
  	change_column_default(:worked_holidays, :additional_off, 0)
  	change_column_default(:worked_holidays, :additional_pay, 0)
  end
end
