class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.references :user
      t.references :designation
      t.text :manager_id
      t.string :employee_name
      t.string :email      
      t.date :joined_at
      t.date :dob
      t.text :address
      t.string :land_no
      t.string :mobile_no
      t.boolean :resigned
      t.date :resigned_at
      t.text :qualifications
      t.decimal :basic_salary, :default => 0
      t.decimal :esi, :default => 0
      t.decimal :pf, :default => 0
      t.decimal :klwf, :default => 0
      t.decimal :swf, :default => 0
      t.decimal :total_swf, :default => 0
      t.decimal :tax, :default => 0
      t.decimal :salary, :default => 0
      t.decimal :per_day, :default => 0
      
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type

      t.timestamps
    end
    add_index :employees, :designation_id
    add_index :employees, :user_id
  end
end
