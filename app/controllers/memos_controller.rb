class MemosController < ApplicationController
  load_and_authorize_resource
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Memos"
      @employee_page = params[:employee_page]
  end

  # GET /memos
  # GET /memos.json
  def index
    @memos = user_capabilities(Memo, {:manager => true})
    # puts @memos.to_yaml
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @memos }
    end
  end

  # GET /memos/1
  # GET /memos/1.json
  def show
    @memo = Memo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @memo }
    end
  end

  # GET /memos/new
  # GET /memos/new.json
  def new
    @memo = Memo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @memo }
    end
  end

  # GET /memos/1/edit
  def edit
    @memo = Memo.find(params[:id])
  end

  # POST /memos
  # POST /memos.json
  def create
    params[:memo][:manager_id] = current_user.id
    @memo = Memo.new(params[:memo])

    respond_to do |format|
      if @memo.save
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@memo.user.employee), notice: 'Memo was successfully created.' 
          else
            redirect_to memos_url, notice: 'Memo was successfully created.' 
          end
        }
        format.json { render json: @memo, status: :created, location: @memo }
      else
        @employee_page = @memo.user_id
        format.html { render action: "new", employee_page: params[:employee_page] }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /memos/1
  # PUT /memos/1.json
  def update
    params[:memo][:manager_id] = current_user.id
    @memo = Memo.find(params[:id])

    respond_to do |format|
      if @memo.update_attributes(params[:memo])
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@memo.user.employee), notice: 'Memo was successfully updated.' 
          else 
            redirect_to memos_url, notice: 'Memo was successfully updated.' 
          end
        }
        format.json { head :no_content }
      else
        format.html { render action: "edit", employee_page: params[:employee_page] }
        format.json { render json: @memo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memos/1
  # DELETE /memos/1.json
  def destroy
    @memo = Memo.find(params[:id])
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @memo.destroy

    respond_to do |format|
      format.html { 
        unless employee.nil?
          redirect_to employee_path(employee), notice: 'Memo was successfully deleted.' 
        else
          redirect_to memos_url, notice: 'Memo was successfully deleted.' 
        end
      }
      format.json { head :no_content }
    end
  end
end
