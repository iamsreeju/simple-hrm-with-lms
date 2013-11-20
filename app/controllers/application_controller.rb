class ApplicationController < ActionController::Base	
	protect_from_forgery

	layout "app_layout"

	before_filter :authenticate_user!
  before_filter :initialize_request

	rescue_from CanCan::AccessDenied do |exception|
  		puts "*******************************************"
  		puts exception.message
  		puts "*******************************************"
    	redirect_to dashboard_path, :alert => exception.message
	end

  def after_sign_in_path_for(user)
		  dashboard_path
  end


  def user_capabilities(model, extra = {:manager => false})
      extra[:user] ||= current_user
      if extra[:user].has_role? :admin
          model.order(:user_id)
      else
          @subordinates = extra[:manager] ? extra[:user].my_subordinates : []
          model.order(:user_id).where("user_id = ? or user_id in (?)", extra[:user].id, @subordinates.collect(&:id))
      end
  end


  def initialize_request
      @menus = {}

      @admin_user = current_user.present? && (current_user.has_role? :admin)

      @menus[:dashboard] = {:icon => "dashboard", :path => dashboard_path, :name => "Dashboard", :type => "single"}

      if current_user.present?
          @notifications = {}
          @notifications[:pending] = user_capabilities(LeaveRequest.status_based_requests('pending', 'asc'), {:manager => true}).count
          @notifications[:total] = @notifications[:pending]

          if @admin_user     
              @menus[:settings] = {:icon => "cogs", :path => "#", :name => "Settings", :type => "multiple"}
              @menus[:settings][:sub_menu] =  [
                                {:path => departments_path, :name => "Departments"}, 
                                {:path => designations_path, :name => "Designations"},
                                {:path => leave_types_path, :name => "Leave Types"}
                              ]
          end

          if current_user.employee
              @menus[:profile] = {:icon => "user", :path => employee_path(current_user.employee), :name => "My Profile", :type => "single"}
          end
          
          @menus[:employee] = {:icon => "group", :path => "#", :name => "Employee", :type => "multiple"}
          @menus[:employee][:sub_menu] = [
                            {:path => employees_path, :name => "Profile"},
                            # {:path => leave_statuses_path, :name => "Leave Status"}, 
                            {:path => leave_requests_path, :name => "Leave Request"},
                            {:path => memos_path, :name => "Memo"},                      
                            {:path => loans_path, :name => "Loan"},
                            {:path => advances_path, :name => "Advance/Credit"},
                            {:path => worked_holidays_path, :name => "OT Allowance/Off"},
                            {:path => reports_path, :name => "Monthly Reports"}
                          ] 

          @menus[:messages] = {:icon => "envelope", :path => messages_path, :name => "Messages", :type => "single"}
      end
  end


end
