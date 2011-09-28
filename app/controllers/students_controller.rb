class StudentsController < ApplicationController
  before_filter :get_board
  before_filter :get_student
  before_filter :authorize_student!, :only => [:create]

  respond_to :json, :xml
  respond_to :html, :only => [:create, :update]

  def show
    respond_with do |f|
      f.json{ render :json => @student.output_hash }
      f.xml { render :xml => @student.output_hash }
    end
  end

  # NOTE: DOES NOT CREATE OBJECT, UPDATES OBJECT
  def create 
    @ta = Ta.new(params[:student])

    respond_with

  end

  def update
    if params[:logout] && params[:logout] == true
      @student.destroy
      respond_with do |f|
        f.json { head :success }
        f.xml  { head :success }
      end
      return
    end

    # This one attribute is abstracted as true/false to clients but is actually a date
    # to help with sorting
    if params[:student][:in_queue]
      if params[:student][:in_queue] == "true"
        @student.in_queue = DateTime.now 
      elsif params[:student][:in_queue] == "false"
        @student.in_queue = nil 
        #@student.ta.current_student = nil if @student.ta
        logger.debug "EXECUTED TA NIL"
      end
      params[:student].delete :in_queue
    end

    @student.update_attributes(params[:student])

    respond_with do |f|
      if @student.save
        f.json { render :json => @student.output_hash }
        f.xml  { render :json => @student.output_hash }
      else
        f.json { render :json => @student.errors, :status => :unprocessable_entity }
        f.xml  { render :json => @student.errors, :status => :unprocessable_entity }
      end
    end

  end

  private
    def authorize_student!
      valid = true
      valid = false if params[:token].nil? || @student.token != params[:token]
      if !valid
        respond_with do |f| 
          f.json { head :forbidden }
          f.xml  { head :forbidden }
        end
        return
      end
    end

    def get_board
      @board ||= Board.where(:title => params[:board_id]).first
      if !@board
        respond_with do |f|
          f.json { head :bad_request }
          f.xml  { head :bad_request }
        end
        return
      end
    end

    def get_student
      @student ||= @board.students.where(:_id => params[:id]).first
      if !@student
        respond_with do |f|
          f.json { head :bad_request }
          f.xml { head :bad_request }
        end
      end
    end
end
