class LeaveType < ActiveRecord::Base
  attr_accessible :default_count, :leave_type_name, :without_pay, 
  :month_forward, :year_forward, :forwarded_off
  
  has_many :leave_requests, :dependent => :destroy
  has_many :leave_statuses, :dependent => :destroy

  before_save :set_default_values

  def set_default_values
    if self.without_pay
        self.month_forward = false
        self.year_forward = false
        self.forwarded_off = false
    end
    return true
  end

  # validates_numericality_of :default_count if validates_presence_of :default_count

  if (validates_length_of :leave_type_name, :minimum => 2, :maximum => 50 if validates_presence_of :leave_type_name)
  		validates_format_of :leave_type_name, :with => /^[a-zA-Z\d ]*$/i,
			:message => "can only contain letters and numbers."
  end

end
