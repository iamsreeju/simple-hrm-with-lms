require 'role_model'

class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  default_scope order('name asc')

  include RoleModel

  validate :check_role

  def check_role
      errors.add(:email, "can not process without role!") if self.roles.empty?
  end

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :name, :password, :password_confirmation, :remember_me, :roles, :roles_mask
  # attr_accessible :title, :body

  roles_attribute :roles_mask

  roles :admin, :employee

  has_one :employee, :dependent => :destroy
  has_one :designation, :through => :employee
  has_one :department, :through => :designation
  has_many :advances, :dependent => :destroy
  has_many :loans, :dependent => :destroy
  has_many :leave_statuses, :dependent => :destroy
  has_many :leave_requests, :dependent => :destroy
  has_many :memos, :dependent => :destroy
  has_many :worked_holidays, :dependent => :destroy
  has_many :managers, :dependent => :destroy
  has_many :subordinates, :class_name => "Manager", :foreign_key => "manager_id", :dependent => :destroy
  has_many :manager_created_memos, :class_name => "Memo", :foreign_key => "created_by"
  has_many :manager_updated_memos, :class_name => "Memo", :foreign_key => "updated_by"
  has_many :updated_requests, :class_name => "LeaveRequest", :foreign_key => "action_by"
  has_many :report_lines, :dependent => :destroy

  def my_subordinates      
      if self.has_role? :admin
          User.order(:id)
      else          
          User.where(:id => self.subordinates.collect(&:user_id)).order(:id)
      end
  end

  def my_managers
      User.where(:id => self.managers.collect(&:manager_id)).order(:id)
  end

  def profile_link
      "<a href='#{employee_path(self.employee)}' target='_blank'>#{self.employee.employee_name}</a>".html_safe
  end

  # Intercept Devise to check if User is active
  def self.find_for_authentication(conditions)
      user = super
      if user.present? && user.has_role?(:employee)
          user = (user.employee.present? && user.employee.resigned == false) ? user : nil
      end
      user 
  end

  scope :active_employees, joins(:employee).where("employees.resigned = ?", false)

  scope :current_employees, lambda{|date| active_employees.where("employees.joined_at <= ?", date)}
end
