class Department < ActiveRecord::Base
  attr_accessible :department_name
  has_many :designations
  has_many :users, :through => :designations
  # has_many :employees, :through => :designations

  if ((validates_uniqueness_of :department_name if validates_length_of :department_name, :minimum => 2, :maximum => 50) if validates_presence_of :department_name)
  		validates_format_of :department_name, :with => /^[a-zA-Z\d ]*$/i,
			:message => "can only contain letters and numbers."
  end

end
