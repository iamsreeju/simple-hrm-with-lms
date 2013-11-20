class WorkedHoliday < ActiveRecord::Base
  belongs_to :user
  attr_accessible :full_day, :worked_date, :user_id, :additional_off, 
  :additional_pay, :allowance_amount

  validates_presence_of :worked_date, :additional_off, :additional_pay, :user, :allowance_amount
  validates_numericality_of :additional_off, :additional_pay, :allowance_amount

  validates :worked_date, :uniqueness => { :scope => :user_id, :message => "already added for the day!" }

  after_create :after_create_values

  def after_create_values
  		self.forwarded_type_status("create")
  end

  before_destroy :before_destroy_values

  def before_destroy_values
  		self.forwarded_type_status("delete")
  end

  before_update :after_update_values

  def after_update_values
  		self.forwarded_type_status("update")
  end

  def forwarded_type_status(type)
	  	leave_status = self.user.leave_statuses.joins(:leave_type).readonly(false).where("leave_types.forwarded_off = ?", true).first
	  	if leave_status
		  	case(type)
		  		when "create"
		  			leave_status.available += self.additional_off

		  		when "delete"
		  			leave_status.available -= self.additional_off

		  		when "update"
		  			org_additional_off = WorkedHoliday.find(self.id).additional_off
		  			leave_status.available += self.additional_off - org_additional_off
		  	end
		  	leave_status.save
		end
  end

  def self.process_worked_holidays(params)
    if params[:employees]
      params[:employees].each do |id|
          user = User.find(id)          
          if user
              params[:worked_holiday][:user_id] = id
              worked_holiday = WorkedHoliday.new(params[:worked_holiday])
              worked_holiday.save
          end
      end
    end
  end

  scope :current_worked, where("worked_date >= ?", 
    Date.today.at_beginning_of_month).order("worked_date desc")

  scope :previous_worked, where("worked_date >= ? and worked_date <= ?", 
    Date.today.prev_month.at_beginning_of_month, 
    Date.today.prev_month.at_end_of_month).order("worked_date desc")

end
