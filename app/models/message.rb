class Message < ActiveRecord::Base
  belongs_to :user
  attr_accessible :description, :title, :user_id, :message_date

  validates_presence_of :title

  scope :next_messages, where("message_date >= ?", Date.today).order(:message_date)
end
