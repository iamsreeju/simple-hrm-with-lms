class LoansController < ApplicationController
  load_and_authorize_resource
  before_filter :set_page

  def set_page
      @menus[:employee][:active] = "active"      
      @title = "Loans"
      @employee_page = params[:employee_page]
  end
  
  # GET /loans
  # GET /loans.json
  def index
    # @loans = Loan.all
    @loans = user_capabilities(Loan) #.recent_loans

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @loans }
    end
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
    @loan = Loan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @loan }
    end
  end

  # GET /loans/new
  # GET /loans/new.json
  def new
    @loan = Loan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @loan }
    end
  end

  # GET /loans/1/edit
  def edit
    @loan = Loan.find(params[:id])
  end

  # POST /loans
  # POST /loans.json
  def create
    @loan = Loan.new(params[:loan])

    respond_to do |format|
      if @loan.save
        format.html { 
          unless params[:employee_page].nil?
              redirect_to employee_path(@loan.user.employee), notice: 'Loan was successfully created.' 
          else
              redirect_to loans_url, notice: 'Loan was successfully created.' 
          end
        }
        format.json { render json: @loan, status: :created, location: @loan }
      else
        @employee_page = @loan.user_id
        format.html { render action: "new", employee_page: params[:employee_page] }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /loans/1
  # PUT /loans/1.json
  def update
    @loan = Loan.find(params[:id])

    respond_to do |format|
      if @loan.update_attributes(params[:loan])
        format.html { 
          unless params[:employee_page].nil?
            redirect_to employee_path(@loan.user.employee), notice: 'Loan was successfully updated.' 
          else
            redirect_to loans_url, notice: 'Loan was successfully updated.' 
          end
          }
        format.json { head :no_content }
      else
        format.html { render action: "edit", employee_page: params[:employee_page] }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan = Loan.find(params[:id])
    user = User.find(params[:employee_page]) if params[:employee_page]
    employee = user.employee if user
    @loan.destroy

    respond_to do |format|
      format.html { 
        unless employee.nil?
            redirect_to employee_path(employee), notice: 'Loan was successfully deleted.' 
        else
            redirect_to loans_url, notice: 'Loan was successfully deleted.' 
        end
      }
      format.json { head :no_content }
    end
  end
end
