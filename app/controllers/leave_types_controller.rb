class LeaveTypesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_page

  def set_page
      @menus[:settings][:active] = "active"
      @title = "Leave Types"
  end
  # GET /leave_types
  # GET /leave_types.json
  def index
    @leave_types = LeaveType.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @leave_types }
    end
  end

  # GET /leave_types/1
  # GET /leave_types/1.json
  def show
    @leave_type = LeaveType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @leave_type }
    end
  end

  # GET /leave_types/new
  # GET /leave_types/new.json
  def new
    @leave_type = LeaveType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @leave_type }
    end
  end

  # GET /leave_types/1/edit
  def edit
    @leave_type = LeaveType.find(params[:id])
  end

  # POST /leave_types
  # POST /leave_types.json
  def create
    @leave_type = LeaveType.new(params[:leave_type])

    respond_to do |format|
      if @leave_type.save
        format.html { redirect_to leave_types_url, notice: 'Leave type was successfully created.' }
        format.json { render json: @leave_type, status: :created, location: @leave_type }
      else
        puts @leave_type.errors.to_yaml
        format.html { render action: "new" }
        format.json { render json: @leave_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /leave_types/1
  # PUT /leave_types/1.json
  def update
    @leave_type = LeaveType.find(params[:id])

    respond_to do |format|
      if @leave_type.update_attributes(params[:leave_type])
        format.html { redirect_to leave_types_url, notice: 'Leave type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @leave_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /leave_types/1
  # DELETE /leave_types/1.json
  def destroy
    @leave_type = LeaveType.find(params[:id])
    @leave_type.destroy

    respond_to do |format|
      format.html { redirect_to leave_types_url }
      format.json { head :no_content }
    end
  end
end
