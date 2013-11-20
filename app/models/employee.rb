class Employee < ActiveRecord::Base
  serialize :manager_id

  belongs_to :designation
  # belongs_to :department, :through => :designation
  belongs_to :user

  default_scope order('employee_name asc')

  attr_accessible :user_id, :designation_id, :manager_id, 
  :address, :basic_salary, :dob, :email, :employee_name, :esi, 
  :image_content_type, :image_file_name, :image_file_size, :joined_at, 
  :klwf, :land_no, :mobile_no, :per_day, :pf, :resigned, :resigned_at, 
  :salary, :swf, :total_swf, :tax, :qualifications

  before_save :set_employee_data

  after_save :update_employee_data

  after_create :create_employee_data

  def set_employee_data
    self.per_day = self.basic_salary/26 rescue 0
    self.set_salary
    return
  end

  def update_employee_data
  		self.user.managers.destroy_all
      if self.manager_id
    		self.manager_id.each do |man_id|
    			Manager.create(:user_id => self.user_id, :manager_id => man_id)
    		end
      end
      
      self.user.update_attributes(email: self.email) if self.email_changed?
  end

  def create_employee_data
      LeaveType.order(:id).all.each do |leave|
          LeaveStatus.create(:user_id => self.user_id, :leave_type_id => leave.id, :available => leave.default_count)
      end
  end

  if ((validates_length_of :employee_name, :minimum => 2, :maximum => 50) if validates_presence_of :employee_name)
      validates_format_of :employee_name, :with => /^[a-zA-Z\d ]*$/i,
      :message => "can only contain letters and numbers."
  end

  validates_presence_of :designation

  (validates_uniqueness_of :email if validates_format_of :email, :with => %r{^(?:[_a-z0-9-]+)(\.[_a-z0-9-]+)*@([a-z0-9-]+)(\.[a-zA-Z0-9\-\.]+)*(\.[a-z]{2,4})$}i, :message => "is not valid email address.") if validates_presence_of :email

  def set_salary
    self.salary = self.basic_salary.to_f - self.esi.to_f - self.pf.to_f - 
    self.klwf.to_f - self.tax.to_f - self.swf.to_f
  end

  def set_swf_total
    self.total_swf = self.total_swf.to_f + self.swf.to_f
    self.save
  end

  def total_deduction
    self.esi.to_f + self.pf.to_f + self.klwf.to_f + self.tax.to_f + self.swf.to_f
  end

end
