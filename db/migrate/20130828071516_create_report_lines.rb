class CreateReportLines < ActiveRecord::Migration
  def change
    create_table :report_lines do |t|
      t.references :report
      t.references :user
      t.decimal :report_salary, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_leave_count, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_leave_cut, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_loan_cut, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_advance_cut, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_allowance, :default => 0, :precision => 15, :scale => 5
      t.decimal :report_total, :default => 0, :precision => 15, :scale => 5

      t.timestamps
    end
    add_index :report_lines, :report_id
    add_index :report_lines, :user_id
  end
end
