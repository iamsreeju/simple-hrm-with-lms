class CreateManagers < ActiveRecord::Migration
  def change
    create_table :managers do |t|
      t.references :user
      t.integer :manager_id

      t.timestamps
    end
    add_index :managers, :user_id
  end
end
