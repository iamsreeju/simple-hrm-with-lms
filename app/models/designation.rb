class Designation < ActiveRecord::Base
  belongs_to :department
  has_many :employees
  has_many :users, :through => :employees
  attr_accessible :designation_name, :department_id

  validates_presence_of :department

  if ((validates_uniqueness_of :designation_name if validates_length_of :designation_name, :minimum => 2, :maximum => 50) if validates_presence_of :designation_name)
  		validates_format_of :designation_name, :with => /^[a-zA-Z\d ]*$/i,
			:message => "can only contain letters and numbers."
  end
  
end
