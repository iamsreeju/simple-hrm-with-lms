class LeaveStatus < ActiveRecord::Base
  belongs_to :user, :conditions => ['id != ?', 1]
  belongs_to :leave_type
  attr_accessible :available, :user_id, :leave_type_id

  validates_presence_of :user, :leave_type
  # validates_numericality_of :available if validates_presence_of :available
  validates :leave_type_id, :uniqueness => { :scope => :user_id, :message => "already added for the employee!" }
end
