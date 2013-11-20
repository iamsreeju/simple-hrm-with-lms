class LeaveRequest < ActiveRecord::Base
  belongs_to :user, :conditions => ['id != ?', 1]
  
  belongs_to :leave_type

  attr_accessible :admin, :user_id, :leave_type_id, :action_by, 
  :leave_at, :full_day, :reason, :status

  attr_accessor :admin

  scope :leave_requests, where("leave_at >= ? and status in (?)", Date.today.at_beginning_of_month, ['pending', 'accepted']).order(:leave_at)

  scope :status_based_requests, lambda{|status, order, date = Date.today.at_beginning_of_month| where("leave_at >= ? and status = ?", date, status).order("leave_at #{order}, created_at asc")}

  @@leave_duration = 1.month

  def self.leave_duration
      @@leave_duration
  end

  def is_forwarding
      self.leave_type.month_forward || self.leave_type.year_forward || self.leave_type.forwarded_off
  end

  belongs_to :action_taken_by, :class_name => "User", :foreign_key => "action_by"

  # statuses -> pending, accepted, rejected, cancelled  

  if validate :user, :leave_type, :leave_at
    if validates :leave_at, :uniqueness => { :scope => :user_id, :message => "already applied a leave for the day!" }
        validate :check_leave_status, on: :create 
    end
  end

  before_create :set_create_values

  def set_create_values
    if self.user == self.action_taken_by
        self.status = "pending"
    else
        self.status = "accepted"
    end
  end

  def check_leave_status
    selected_date = self.leave_at
    selected_leave = self.full_day ? 1 : 0.5

    prev_closed = Report.where("report_date = ? and report_status = ?", Date.today.at_beginning_of_month.prev_month, "leaves closed")

    if prev_closed.count == 0 && self.is_forwarding && selected_date >= Date.today.at_beginning_of_month
        errors.add("leave_type", "not enabled yet! Previous month report need to be closed!")
    elsif !self.admin && (selected_date < Date.today || selected_date > Date.today + @@leave_duration)
        errors.add("leave_at", "should be a valid date in next 30 days!")
    else
        leave_status = self.user.leave_statuses.find_by_leave_type_id(self.leave_type_id)
        if leave_status        
            leave_type = leave_status.leave_type
            if self.leave_type.without_pay
              self.user.leave_statuses.each do |status|
                availability_matrix = LeaveRequest.availability_matrix(status, selected_date)
                leave_status = availability_matrix[0]
                leave_count = availability_matrix[1]
                if leave_status.available > 0 && (leave_count + selected_leave) <= leave_status.available
                  errors.add("leave_type", "is not applicable! Use other leave options first.")
                  break
                end
              end
              # errors.add("leave_type", "is not applicable for now!")
            else
              availability_matrix = LeaveRequest.availability_matrix(leave_status, selected_date)
              leave_status = availability_matrix[0]
              leave_count = availability_matrix[1]

              if leave_status.available <= 0 || (leave_count + selected_leave) > leave_status.available
                errors.add("leave_type", "is not applicable! Insufficient leave availability!")
              end
            end            
        else
            errors.add("leave_type", "is not allotted for you! Please check leave status.")
        end 
    end
  end


  def self.availability_matrix(leave_status, selected_date)
      leave_type = leave_status.leave_type
      if selected_date.year > Date.today.year
          if leave_type.year_forward
              # Same
          elsif leave_type.month_forward
              leave_status.available = 0
          else
              leave_status.available = leave_type.default_count
          end
      elsif selected_date.month > Date.today.month
          if leave_type.year_forward
              # Same
          elsif leave_type.month_forward
              # Same
          else
              leave_status.available = leave_type.default_count
          end
      end

      if leave_type.year_forward
          leaves_taken = LeaveRequest.leaves_taken(leave_status, Date.today.at_beginning_of_month, Date.today + @@leave_duration + 1, "count")
      elsif leave_type.month_forward
          leaves_taken = LeaveRequest.leaves_taken(leave_status, Date.today.at_beginning_of_month, Date.today.at_end_of_year, "count")
      else
          leaves_taken = LeaveRequest.leaves_taken(leave_status, selected_date.at_beginning_of_month, selected_date.at_end_of_month, "count")
      end

      [leave_status, leaves_taken]
  end


  def self.leaves_taken(leave_status, start_date, end_date, type = "all")
      leaves_taken = leave_status.user.leave_requests
        .where(:leave_type_id => leave_status.leave_type_id, :status => ["accepted", "pending"])
        .where("leave_at >= ? and leave_at <= ?", start_date, end_date)

      case(type)
          when "count"
              leaves_taken.where(:full_day => true).count.to_f + (leaves_taken.where(:full_day => false).count.to_f/2)

          when "all"
              leaves_taken
      end  
  end

end
