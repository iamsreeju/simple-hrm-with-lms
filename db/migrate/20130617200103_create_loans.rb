class CreateLoans < ActiveRecord::Migration
  def change
    create_table :loans do |t|
      t.references :user
      t.decimal :amount, :default => 0
      t.decimal :monthly_cut, :default => 0
      t.decimal :balance, :default => 0

      t.timestamps
    end
    add_index :loans, :user_id
  end
end
