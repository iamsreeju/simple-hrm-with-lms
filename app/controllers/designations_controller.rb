class DesignationsController < ApplicationController
  load_and_authorize_resource 
  before_filter :set_page

  def set_page
      @menus[:settings][:active] = "active"
      @title = "Designations"
  end
  # GET /designations
  # GET /designations.json
  def index
    @designations = Designation.order("id desc").all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @designations }
    end
  end

  # GET /designations/1
  # GET /designations/1.json
  def show
    @designation = Designation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @designation }
    end
  end

  # GET /designations/new
  # GET /designations/new.json
  def new
    @designation = Designation.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @designation }
    end
  end

  # GET /designations/1/edit
  def edit
    @designation = Designation.find(params[:id])
  end

  # POST /designations
  # POST /designations.json
  def create
    @designation = Designation.new(params[:designation])

    respond_to do |format|
      if @designation.save
        format.html { redirect_to designations_path, notice: 'Designation was successfully created.' }
        format.json { render json: @designation, status: :created, location: @designation }
      else
        format.html { render action: "new" }
        format.json { render json: @designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /designations/1
  # PUT /designations/1.json
  def update
    @designation = Designation.find(params[:id])

    respond_to do |format|
      if @designation.update_attributes(params[:designation])
        format.html { redirect_to designations_path, notice: 'Designation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @designation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /designations/1
  # DELETE /designations/1.json
  def destroy
    puts current_user.to_yaml
    
    @designation = Designation.find(params[:id])
    @designation.destroy

    puts current_user.to_yaml

    respond_to do |format|
      format.html { redirect_to designations_url }
      format.json { head :no_content }
    end
  end
end
