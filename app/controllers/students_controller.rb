class StudentsController < ApplicationController
  before_filter :authorize_student!, :only => [:create]
  before_filter :get_student

  respond_to :json, :xml
  def show
    respond_with do |f|
      f.json{ render :json => @student.output_hash }
      f.xml { render :xml => @student.output_hash }
    end
  end

  # NOTE: DOES NOT CREATE OBJECT, UPDATES OBJECT
  def create
    
  end

  private
    def authorize_student!
      valid = true
      valid = false if params[:id].nil? || params[:token].nil?

      @board = Board.find(:board_id)
      @student = @board.students.find(params[:id])

      valid = false if @student.nil?
      valid = false if @student.token != params[:token]

      if !valid?
        format.json { head :forbidden }
      end
    end

    def get_student
      @student ||= Board.where(:title => params[:board_id]).first.students.find(params[:id])
    end
end
