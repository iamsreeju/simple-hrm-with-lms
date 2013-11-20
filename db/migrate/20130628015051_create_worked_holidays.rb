class CreateWorkedHolidays < ActiveRecord::Migration
  def change
    create_table :worked_holidays do |t|
      t.references :user
      t.date :worked_date
      t.integer :additional_off
      t.integer :additional_pay

      t.timestamps
    end
    add_index :worked_holidays, :user_id
  end
end
