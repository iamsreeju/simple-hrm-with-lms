class EmployeesController < ApplicationController
  load_and_authorize_resource 
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"
      if current_user.has_role? :admin
          @employees = Employee.order(:id)
      else
          @employees = user_capabilities(Employee, {:manager => true})
      end
      @title = "Employees" 
  end

  # GET /employees
  # GET /employees.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employees }
    end
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
    @employee = @employees.find(params[:id])
    user = @employee.user

    @leave_statuses = user_capabilities(LeaveStatus, {:manager => false, :user => user})

    @previous_requests = LeaveRequest.where("leave_at >= ? and leave_at <= ? and user_id = ?", 
    Date.today.prev_month.at_beginning_of_month, Date.today.prev_month.at_end_of_month, user.id)
    .order("leave_at desc")

    @accepted_requests = user.leave_requests.status_based_requests('accepted', 'asc', Date.today.at_beginning_of_month)
    @pending_requests = user.leave_requests.status_based_requests('pending', 'asc', Date.today.prev_month.at_beginning_of_month)

    @memos = user_capabilities(Memo, {:manager => false, :user => user})

    if user == current_user || @admin_user
      @loans = user_capabilities(Loan, {:manager => false, :user => user}) #.recent_loans
      @advances = user_capabilities(Advance, {:manager => false, :user => user}).current_advances
      @previous_advances = user_capabilities(Advance, {:manager => false, :user => user}).previous_advances      
      @worked_holidays = user_capabilities(WorkedHoliday, {:manager => false, :user => user}).current_worked
      @previous_worked_holidays = user_capabilities(WorkedHoliday, {:manager => false, :user => user}).previous_worked
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/new
  # GET /employees/new.json
  def new
    @employee = Employee.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employee }
    end
  end

  # GET /employees/1/edit
  def edit
    @employee = @employees.find(params[:id])
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(params[:employee])
    password = params[:password] == "" ? "changeme" : params[:password]
    @user = User.new(:name => params[:employee][:employee_name], email: params[:employee][:email], password: password, password_confirmation: password)
    
    respond_to do |format|
      if @employee.valid?
        @user.roles = [:employee]     
        if @user.save
          @employee.user_id = @user.id
          @employee.save
          format.html { redirect_to @employee, notice: 'Employee was successfully created.' }
          format.json { render json: @employee, status: :created, location: @employee }
        else
          format.html { render action: "new" }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /employees/1
  # PUT /employees/1.json
  def update
    @employee = @employees.find(params[:id])
    password = params[:password] == "" ? nil : params[:password]

    respond_to do |format|
      if @employee.update_attributes(params[:employee])
        @employee.user.update_attributes(password: password, password_confirmation: password) if password.present?
        format.html { redirect_to @employee, notice: 'Employee was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    @employee = @employees.find(params[:id])
    @employee.user.destroy

    respond_to do |format|
      format.html { redirect_to employees_url }
      format.json { head :no_content }
    end
  end
end
