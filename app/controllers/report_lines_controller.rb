class ReportLinesController < ApplicationController
  load_and_authorize_resource
  before_filter :set_page, only: [:index]

  def set_page
    @menus[:employee][:active] = "active"
    @title = "Monthly Reports"
  end

  # GET reports/1/report_lines
  # GET reports/1/report_lines.json
  def index
    @report = Report.find(params[:report_id])
    @report_lines = @report.report_lines
    @title = @report.report_title

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @report_lines }
    end
  end

  # GET reports/1/report_lines/1
  # GET reports/1/report_lines/1.json
  def show
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @report_line }
    end
  end

  # GET reports/1/report_lines/new
  # GET reports/1/report_lines/new.json
  def new
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.build

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @report_line }
    end
  end

  # GET reports/1/report_lines/1/edit
  def edit
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.find(params[:id])
  end

  # POST reports/1/report_lines
  # POST reports/1/report_lines.json
  def create
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.build(params[:report_line])

    respond_to do |format|
      if @report_line.save
        format.html { redirect_to(report_report_lines_url(@report), :notice => 'Report line was successfully created.') }
        format.json { render :json => @report_line, :status => :created, :location => [@report_line.report, @report_line] }
      else
        format.html { render :action => "new" }
        format.json { render :json => @report_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT reports/1/report_lines/1
  # PUT reports/1/report_lines/1.json
  def update
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.find(params[:id])

    respond_to do |format|
      if @report_line.update_attributes(params[:report_line])
        format.html { redirect_to(report_report_lines_url(@report), :notice => 'Report line was successfully updated.') }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @report_line.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE reports/1/report_lines/1
  # DELETE reports/1/report_lines/1.json
  def destroy
    @report = Report.find(params[:report_id])
    @report_line = @report.report_lines.find(params[:id])
    @report_line.destroy

    respond_to do |format|
      format.html { redirect_to report_report_lines_url(@report) }
      format.json { head :ok }
    end
  end
end
