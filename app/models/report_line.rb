class ReportLine < ActiveRecord::Base
  belongs_to :report
  belongs_to :user, :conditions => ['id != ?', 1]

  attr_accessible :report_id, :user_id, :report_advance_cut, 
  :report_allowance, :report_leave_count, :report_leave_cut, 
  :report_loan_cut, :report_salary, :report_total, :report_basic,
  :report_deduct

  validates :user_id, :uniqueness => { :scope => :report_id, :message => "already exists!" }

  before_save :check_before_save

  validates_presence_of :user, :report_advance_cut, 
  :report_allowance, :report_leave_count, :report_leave_cut, 
  :report_loan_cut, :report_salary, :report_basic,
  :report_deduct

  validates_numericality_of :report_advance_cut, :report_allowance, 
  :report_leave_count, :report_leave_cut, :report_loan_cut, 
  :report_salary, :report_basic, :report_deduct

  def check_before_save
  	self.report_total = self.report_salary.to_f + 
		self.report_allowance.to_f - self.report_leave_cut.to_f - 
		self.report_loan_cut.to_f - self.report_advance_cut.to_f

    if self.report_total > 0
        self.report_total = check_salary_mode(self.report_total)
    elsif self.report_total < 0
        pos_total = self.report_total * -1
        self.report_total = check_salary_mode(pos_total) * -1
    end
  end

  def check_salary_mode(pos_total)
      salary_mode = pos_total % 10
      if salary_mode >= 5
          pos_total += 10 - salary_mode
      else
          pos_total -= salary_mode
      end
      pos_total
  end

  # after_save :check_after_save

  def negative_salary_to_advance
    if self.report_total < 0
        advance_date = self.report.report_date.at_end_of_month + 1
        advance = self.user.advances.new(took_at: advance_date, amount: self.report_total * -1)
        advance.save
    end
  end

end
