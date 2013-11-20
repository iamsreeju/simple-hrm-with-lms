class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :department_name, default: ""

      t.timestamps
    end
  end
end
