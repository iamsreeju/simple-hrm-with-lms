class CreateAdvances < ActiveRecord::Migration
  def change
    create_table :advances do |t|
      t.references :user
      t.decimal :amount, :default => 0
      t.date :took_at
      t.string :remarks

      t.timestamps
    end
    add_index :advances, :user_id
  end
end
