class Report < ActiveRecord::Base
  has_many :report_lines, :dependent => :destroy  
  attr_accessible :report_date, :report_status  

  before_create :process_before_create

  def process_before_create
  	self.report_date = self.report_date.at_beginning_of_month
	self.report_status = "created"
  end

  validate :check_pending_leaves if validates_presence_of :report_date

  def check_pending_leaves
  	leaves = LeaveRequest.where("leave_at >= ? and leave_at <= ? and status = 
  	 'pending'", self.report_date.at_beginning_of_month, self.report_date.at_end_of_month)
  	errors.add(:report_date, "contains pending leaves!") unless leaves.empty?
  end

  def proper_month
  		self.report_date.strftime("%B %Y")
  end

  def report_title
  		"Report " + self.report_date.strftime("%B %Y")
  end

  def close_loans_advances
  	end_date = self.report_date.at_end_of_month

  	employees = User.current_employees(end_date)
  	employees.each do |employee|
  		employee.employee.set_swf_total
  		# report_loans = employee.loans.where("balance > 0")
  		report_loans = employee.loans.report_loans(end_date)
  		report_loans.each {|loan| loan.perform_deduction }  		
  		report_line = self.report_lines.find_by_user_id(employee.id)
  		report_line.negative_salary_to_advance
  	end
  	self.report_status = "loans closed"
	self.save
  end

  def close_leave_status
  	start_date = self.report_date.at_beginning_of_month
  	end_date = self.report_date.at_end_of_month
  	selected_date = self.report_date.at_end_of_month + 1

	employees = User.current_employees(end_date)
	employees.each do |employee|
		employee.leave_statuses.each do |leave_status|
			leave_type = leave_status.leave_type
					
      		if leave_type.forwarded_off || leave_type.year_forward || (selected_date.year == self.report_date.year && leave_type.month_forward)
			  	taken = LeaveRequest.leaves_taken(leave_status, start_date, end_date, "count")
			  	leave_status.available += leave_type.default_count - taken
			else
			  	leave_status.available = leave_type.default_count
			end
	      	
	      	leave_status.save
		end
	end

	LeaveRequest.where("leave_at < ?", self.report_date.at_beginning_of_month).destroy_all

	self.report_status = "leaves closed"
	self.save
  end

  def process_monthly_report
  	date = self.report_date
  	end_date = self.report_date.at_end_of_month

	employees = User.current_employees(end_date)
	unless self.report_lines.empty?
		employees = employees.where("users.id not in (?)", self.report_lines.map(&:user_id))
	end	

	employees.each do |employee|
		report_line = self.report_lines.new
		
		report_line.user_id = employee.id

		report_line.report_basic = employee.employee.basic_salary.to_f

		report_line.report_salary = employee.employee.salary.to_f

		report_line.report_deduct = report_line.report_basic - report_line.report_salary

		basic_per_day = (employee.employee.basic_salary/26).to_i
		
		# report_loans = employee.loans.where("balance > 0")
		report_loans = employee.loans.report_loans(end_date)

		report_line.report_loan_cut = report_loans.sum(:monthly_cut)

		report_advances = employee.advances.where("took_at >= ? and 
		took_at <= ?", date.at_beginning_of_month, date.at_end_of_month)

		report_line.report_advance_cut = report_advances.sum(:amount)
		
		without_pay_leaves = employee.leave_requests.joins(:leave_type)
		.where("leave_requests.leave_at >= ? and leave_requests.leave_at <= ? 
		and leave_requests.status = 'accepted' and leave_types.without_pay = ?", 
		date.at_beginning_of_month, date.at_end_of_month, true)

		report_line.report_leave_count = without_pay_leaves.where("leave_requests.full_day = ?", true).count +
		without_pay_leaves.where("leave_requests.full_day = ?", false).count/2

		report_line.report_leave_cut = basic_per_day * report_line.report_leave_count

		report_allowances = employee.worked_holidays.where("worked_date >= ? 
		and worked_date <= ?", date.at_beginning_of_month, date.at_end_of_month)

		report_line.report_allowance = report_allowances.sum(:allowance_amount) + 
		(report_allowances.sum(:additional_pay) * basic_per_day)

		report_line.save
	end
	self.report_status = "processed"
	self.save
  end

end
