class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.date :report_date
      t.string :report_status

      t.timestamps
    end
  end
end
