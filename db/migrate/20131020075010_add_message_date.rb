class AddMessageDate < ActiveRecord::Migration
  def change
  		add_column :messages, :message_date, :date
  end
end
