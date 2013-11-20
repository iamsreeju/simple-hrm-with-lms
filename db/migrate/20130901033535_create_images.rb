class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.integer :imageable_id
      t.string :imageable_type
      t.string :image_file_name
      t.string :image_file_size
      t.string :image_content_type
      t.boolean :image_active

      t.timestamps
    end
  end
end
