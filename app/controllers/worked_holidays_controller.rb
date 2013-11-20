class WorkedHolidaysController < ApplicationController
  load_and_authorize_resource 
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Worked Holidays"
      @employee_page = params[:employee_page]
  end
  
  # GET /worked_holidays
  # GET /worked_holidays.json
  def index
    @worked_holidays = user_capabilities(WorkedHoliday).current_worked

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @worked_holidays }
    end
  end

  # GET /worked_holidays/1
  # GET /worked_holidays/1.json
  def show
    @worked_holiday = WorkedHoliday.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @worked_holiday }
    end
  end

  # GET /worked_holidays/new
  # GET /worked_holidays/new.json
  def new
    @worked_holiday = WorkedHoliday.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @worked_holiday }
    end
  end

  # GET /worked_holidays/1/edit
  def edit
    @worked_holiday = WorkedHoliday.find(params[:id])
  end

  # POST /worked_holidays
  # POST /worked_holidays.json
  def create
    admin = User.find(1)
    params[:worked_holiday][:user_id] = admin.id
    @worked_holiday = WorkedHoliday.new(params[:worked_holiday])

    respond_to do |format|
      if @worked_holiday.valid?
        WorkedHoliday.process_worked_holidays(params)
        format.html { 
          unless params[:employee_page].nil?
            redirect_to worked_holidays_url, notice: 'Worked holiday was successfully created.' 
          else
            redirect_to worked_holidays_url, notice: 'Worked holiday was successfully created.' 
          end
        }
        format.json { render json: @worked_holiday, status: :created, location: @worked_holiday }
      else
        puts @worked_holiday.errors.to_yaml
        format.html { render action: "new", employee_page: params[:employee_page] }
        format.json { render json: @worked_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /worked_holidays/1
  # PUT /worked_holidays/1.json
  def update
    @worked_holiday = WorkedHoliday.find(params[:id])

    respond_to do |format|
      if @worked_holiday.update_attributes(params[:worked_holiday])
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@worked_holiday.user.employee), notice: 'Worked holiday was successfully updated.' 
          else
            redirect_to worked_holidays_url, notice: 'Worked holiday was successfully updated.' 
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit", employee_page: params[:employee_page] }
        format.json { render json: @worked_holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /worked_holidays/1
  # DELETE /worked_holidays/1.json
  def destroy
    @worked_holiday = WorkedHoliday.find(params[:id])
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @worked_holiday.destroy

    respond_to do |format|
      format.html { 
        unless employee.nil?
          redirect_to employee_path(employee), notice: 'Worked holiday was successfully deleted.' 
        else
          redirect_to worked_holidays_url, notice: 'Worked holiday was successfully deleted.' 
        end
      }
      format.json { head :no_content }
    end
  end
end
