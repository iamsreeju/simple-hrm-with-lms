class Loan < ActiveRecord::Base
  belongs_to :user, :conditions => ['id != ?', 1]

  attr_accessible :user_id, :amount, :balance, 
  :monthly_cut, :status, :took_at

  validates_presence_of :amount, :balance, :monthly_cut, :took_at
  validates_numericality_of :amount, :balance, :monthly_cut

  before_save :check_before_save

  def check_before_save
  		if self.balance < self.monthly_cut
  			self.monthly_cut = self.balance
  		elsif self.balance < 0
  			self.balance = 0
  		end
  end

  def perform_deduction
  		self.balance -= self.monthly_cut
  		self.save
  end

  scope :report_loans, lambda{|date| where("balance > 0 and took_at <= ?", date) }

  scope :recent_loans, where("took_at >= ? or balance > ?", Date.today.prev_month.at_beginning_of_month, 0).order("balance desc")
end
