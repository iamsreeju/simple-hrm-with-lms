class LeaveRequestsController < ApplicationController
  load_and_authorize_resource
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Leave Requests"
      @employee_page = params[:employee_page]
  end
  
  # GET /leave_requests
  # GET /leave_requests.json
  def index
    params[:show_history] = true
    if params[:history].present?
        historical_leaves = LeaveRequest.where("status = ? and leave_at >= ? and leave_at < ?", "accepted", Date.today.prev_month.at_beginning_of_month, Date.today).order("leave_at desc")
        @previous_requests = user_capabilities(historical_leaves, {:manager => true})
    else
        @accepted_requests = user_capabilities(LeaveRequest.status_based_requests('accepted', 'asc').where("leave_at >= ?", Date.today), {:manager => true})
        @pending_requests = user_capabilities(LeaveRequest.status_based_requests('pending', 'asc', Date.today.prev_month.at_beginning_of_month), {:manager => true})
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leave_requests }
    end
  end

  # GET /leave_requests/1
  # GET /leave_requests/1.json
  def show
    @leave_request = LeaveRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leave_request }
    end
  end

  # GET /leave_requests/new
  # GET /leave_requests/new.json
  def new
    @leave_request = LeaveRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leave_request }
    end
  end

  # GET /leave_requests/1/edit
  def edit
    @leave_request = LeaveRequest.find(params[:id])
  end

  # POST /leave_requests
  # POST /leave_requests.json
  def create
    @leave_request = LeaveRequest.new(params[:leave_request])
    @leave_request.admin = @admin_user
    @leave_request.action_taken_by = current_user

    respond_to do |format|
      if @leave_request.save
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@leave_request.user.employee), notice: 'Leave request was successfully created.' 
          else
            redirect_to leave_requests_url, notice: 'Leave request was successfully created.' 
          end
        }
        format.json { render json: @leave_request, status: :created, location: @leave_request }
      else
        @employee_page = @leave_request.user_id
        format.html { render action: "new", employee_page: params[:employee_page] }
        format.json { render json: @leave_request.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leave_requests/1
  # PUT /leave_requests/1.json
  def update
    @leave_request = LeaveRequest.find(params[:id])    
    params[:status] = "rejected" if params[:status].nil? || !["accepted", "rejected"].include?(params[:status])
    
    if params[:status] == "rejected"
        @leave_request.destroy
        user = User.find(params[:employee_page]) if params[:employee_page]
        employee = user.employee if user
        unless employee.nil?
          redirect_to employee_path(employee), notice: 'Leave request was successfully rejected.' 
        else
          redirect_to leave_requests_url, notice: 'Leave request was successfully rejected.' 
        end
    else
        @leave_request.admin = @admin_user
        @leave_request.action_taken_by = current_user
        @leave_request.status = params[:status]

        respond_to do |format|
          if @leave_request.save
            format.html { 
              unless params[:employee_page].nil?
                redirect_to employee_path(@leave_request.user.employee), notice: 'Leave request was successfully approved.' 
              else
                redirect_to leave_requests_url, notice: 'Leave request was successfully approved.' 
              end
            }
            format.json { head :no_content }
          else
            format.html { render action: "edit", employee_page: params[:employee_page] }
            format.json { render json: @leave_request.errors, status: :unprocessable_entity }
          end
        end
    end
  end

  # DELETE /leave_requests/1
  # DELETE /leave_requests/1.json
  def destroy
    @leave_request = LeaveRequest.find(params[:id])    
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @leave_request.destroy

    respond_to do |format|
      format.html { 
          unless employee.nil?
            redirect_to employee_path(employee), notice: 'Leave request was successfully deleted.' 
          else
            redirect_to leave_requests_url, notice: 'Leave request was successfully deleted.' 
          end
      }
      format.json { head :no_content }
    end
  end
end
