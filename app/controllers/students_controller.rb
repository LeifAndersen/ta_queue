class StudentsController < ApplicationController
  before_filter :get_board
  before_filter :get_student
  before_filter :authorize_student!, :only => [:create]

  respond_to :json, :xml
  def show
    respond_with do |f|
      f.json{ render :json => @student.output_hash }
      f.xml { render :xml => @student.output_hash }
    end
  end

  # NOTE: DOES NOT CREATE OBJECT, UPDATES OBJECT
  def create 
    if params[:logout] && params[:logout] == true
      @student.destroy
      respond_with do |f|
        f.html { redirect_to board_login_path(@board) }
        f.json { head :success }
        f.xml  { head :success }
      end
      return
    end

    if params[:in_queue]
      @student.in_queue = params[:in_queue]
    end

    if params[:location]
      @student.location = params[:location]
    end

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
          f.html { redirect_to root_path }
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
          f.html { redirect_to root_path }
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
          f.html { redirect_to root_path }
          f.json { head :bad_request }
          f.xml { head :bad_request }
        end
      end
    end
end
