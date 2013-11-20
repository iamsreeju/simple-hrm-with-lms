class AdvancesController < ApplicationController
  load_and_authorize_resource 
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Advances/Credits"
      @employee_page = params[:employee_page]
  end

  # GET /advances
  # GET /advances.json
  def index
    @advances = user_capabilities(Advance).current_advances

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @advances }
    end
  end

  # GET /advances/1
  # GET /advances/1.json
  def show
    @advance = Advance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @advance }
    end
  end

  # GET /advances/new
  # GET /advances/new.json
  def new
    @advance = Advance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @advance }
    end
  end

  # GET /advances/1/edit
  def edit
    @advance = Advance.find(params[:id])
  end

  # POST /advances
  # POST /advances.json
  def create
    @advance = Advance.new(params[:advance])

    respond_to do |format|
      if @advance.save
        format.html { 
          unless params[:employee_page].nil?
              redirect_to employee_path(@advance.user.employee), notice: 'Advance was successfully created.' 
          else
              redirect_to advances_url, notice: 'Advance was successfully created.' 
          end
        }
        format.json { render json: @advance, status: :created, location: @advance }
      else
        @employee_page = @advance.user_id
        format.html { render action: "new", employee_page: params[:employee_page] }
        format.json { render json: @advance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /advances/1
  # PUT /advances/1.json
  def update
    @advance = Advance.find(params[:id])

    respond_to do |format|
      if @advance.update_attributes(params[:advance])
        format.html { 
          unless params[:employee_page].nil?
              redirect_to employee_path(@advance.user.employee), notice: 'Advance was successfully updated.' 
          else
              redirect_to advances_url, notice: 'Advance was successfully updated.' 
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit", employee_page: params[:employee_page] }
        format.json { render json: @advance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /advances/1
  # DELETE /advances/1.json
  def destroy
    @advance = Advance.find(params[:id])
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @advance.destroy    

    respond_to do |format|
      format.html { 
        unless employee.nil?
            redirect_to employee_path(employee, notice: 'Advance was successfully deleted.')
        else
            redirect_to advances_url, notice: 'Advance was successfully deleted.'
        end
      }
      format.json { head :no_content }
    end
  end
end
