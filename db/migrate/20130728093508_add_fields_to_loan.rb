class AddFieldsToLoan < ActiveRecord::Migration
  def change
  	add_column :loans, :status, :string, :default => "open"
  	add_column :loans, :took_at, :date
  end
end
