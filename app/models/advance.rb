class Advance < ActiveRecord::Base
  belongs_to :user, :conditions => ['id != ?', 1]

  attr_accessible :user_id, :amount, :remarks, :took_at, :status

  validates_presence_of :user, :amount, :took_at

  validates_numericality_of :amount

  scope :current_advances, where("took_at >= ?", 
  	Date.today.at_beginning_of_month).order("took_at desc")

  scope :previous_advances, where("took_at >= ? and took_at <= ?", 
  	Date.today.prev_month.at_beginning_of_month, 
  	Date.today.prev_month.at_end_of_month).order("took_at desc")
end
