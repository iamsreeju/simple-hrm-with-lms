class CreateDesignations < ActiveRecord::Migration
  def change
    create_table :designations do |t|
      t.string :designation_name
      t.references :department

      t.timestamps
    end
    add_index :designations, :department_id
  end
end
