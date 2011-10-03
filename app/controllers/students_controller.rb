class StudentsController < ApplicationController
  before_filter :get_board
  before_filter :get_student, :except => [:index, :new, :create]
  before_filter :authenticate_current_student_or_ta!, :except => [:create]

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
    @student = @board.students.new(params[:student].merge( { token: SecureRandom.uuid } ))
    respond_with do |f|
      if @student.save
        session['user_id'] = @student.id if request.format == 'html'
        f.html { redirect_to (board_path @board) }
        f.json { render :json => { location: @student.location, token: @student.token, id: @student.id, username: @student.username }, :status => :created }
        f.xml  { render :xml => { token: @student.token, id: @student.id, username: @student.username }, :status => :created }
      else
        f.html { redirect_to board_login_path @board }
        f.json { render :json => @student.errors, :status => :unprocessable_entity }
        f.xml  { render :xml => { token: @student.token, id: @student.id, username: @student.username } }
      end
    end
  end

  def update
    # This one attribute is abstracted as true/false to clients but is actually a date
    # to help with sorting
    if params[:student][:in_queue]
      if params[:student][:in_queue].to_s == "true"
        @student.in_queue = DateTime.now 
      elsif params[:student][:in_queue].to_s == "false"
        @student.in_queue = nil 
        @student.ta = nil unless @student.ta.nil?
        logger.debug "EXECUTED TA NIL"
      end
      params[:student].delete :in_queue
      @student.save
    end

    @student.update_attributes(params[:student])
    @student.save

    respond_with do |f|
      f.json { render :json => @student }
      f.xml  { render :xml => @student }
    end
  end

  def destroy
    @student.destroy
    respond_with do |f|
      f.html { redirect_to board_login_path @board }
    end
  end

  private
=begin
    def authorize_student!
      if session['user_id'] != @student.id
        # TODO Fix security bug, need to check token on ta
        if params[:token].nil? || (@student.token != params[:token] && @board.tas.where(:_id => params[:ta_id]).first.nil?)
          respond_with do |f| 
            f.json { head :unauthorized }
            f.xml  { head :unauthorized }
          end
          return
        end
      end
    end
=end

    def get_board
      @board ||= Board.where(:title => params[:board_id]).first
      if !@board
        puts "NO BOARD!!!"
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
