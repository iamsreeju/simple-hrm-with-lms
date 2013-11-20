class LeaveStatusesController < ApplicationController
  load_and_authorize_resource 
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Leave Statuses"
      @employee_page = params[:employee_page]
  end
  
  # GET /leave_statuses
  # GET /leave_statuses.json
  def index
    @leave_statuses = user_capabilities(LeaveStatus, {:manager => true})

    respond_to do |format|
      format.html # index.html.erb
      format.json {
        render json: @leave_statuses 
      }
    end
  end

  # GET /leave_statuses/1
  # GET /leave_statuses/1.json
  def show
    @leave_status = LeaveStatus.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leave_status }
    end
  end

  # GET /leave_statuses/new
  # GET /leave_statuses/new.json
  def new
    @leave_status = LeaveStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leave_status }
    end
  end

  # GET /leave_statuses/1/edit
  def edit
    @leave_status = LeaveStatus.find(params[:id])
  end

  # POST /leave_statuses
  # POST /leave_statuses.json
  def create
    @leave_status = LeaveStatus.new(params[:leave_status])

    respond_to do |format|
      if @leave_status.save
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@leave_status.user.employee), notice: 'Leave status was successfully created.' 
          else
            redirect_to leave_statuses_url, notice: 'Leave status was successfully created.' 
          end
          }
        format.json { render json: @leave_status, status: :created, location: @leave_status }
      else
        @employee_page = @leave_status.user_id
        format.html { render action: "new" }
        format.json { render json: @leave_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leave_statuses/1
  # PUT /leave_statuses/1.json
  def update
    @leave_status = LeaveStatus.find(params[:id])

    respond_to do |format|
      if @leave_status.update_attributes(params[:leave_status])
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@leave_status.user.employee), notice: 'Leave status was successfully updated.' 
          else
            redirect_to leave_statuses_url, notice: 'Leave status was successfully updated.' 
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave_status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_statuses/1
  # DELETE /leave_statuses/1.json
  def destroy
    @leave_status = LeaveStatus.find(params[:id])
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @leave_status.destroy

    respond_to do |format|
      format.html { 
        unless employee.nil?
          redirect_to employee_path(employee), notice: 'Leave status was successfully deleted.' 
        else
          redirect_to leave_statuses_url, notice: 'Leave status was successfully deleted.' 
        end
      }
      format.json { head :no_content }
    end
  end
end
