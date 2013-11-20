class CreateMemos < ActiveRecord::Migration
  def change
    create_table :memos do |t|
      t.references :user
      t.integer :created_by
      t.integer :updated_by
      t.string :title
      t.text :message
      t.text :response
      t.text :action_taken

      t.timestamps
    end
    add_index :memos, :user_id
  end
end
