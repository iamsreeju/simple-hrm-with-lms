class AddFulldayToWorked < ActiveRecord::Migration
  def change
  		add_column :worked_holidays, :full_day, :boolean, :default => true
  		change_column :worked_holidays, :additional_off, :float
  		change_column :worked_holidays, :additional_pay, :float
  end
end
