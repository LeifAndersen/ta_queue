class StudentsController < ApplicationController
  before_filter :get_board
  before_filter :get_student, :except => [:index, :new, :create]
  before_filter :authenticate_current_student_or_ta!, :except => [:create, :ta_accept]
  before_filter :authenticate_ta!, :only => [:ta_accept]

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
    @student.update_attributes(params[:student])

    respond_with @student
  end

  def destroy
    @student.destroy
    respond_with do |f|
      f.html { redirect_to board_login_path @board }
    end
  end

###### ACTIONS ######

  def ta_accept
    current_user.accept_student! @student
    respond_with @board, :include => [:students, :tas]
  end

###### PRIVATE ######

  private

    def get_board
      @board ||= Board.where(:title => params[:board_id]).first
      if !@board
        puts "NO BOARD!!!"
        respond_with do |f|
          f.json { render :json => { error: "Invalid board id" }, :status => :bad_request }
          f.xml  { render :json => { error: "Invalid board id" }, :status => :bad_request }
        end
        return
      end
    end

    def get_student
      @student ||= @board.students.where(:_id => params[:id]).first
      if !@student
        respond_with do |f|
          f.json { render :json => { error: "This student does not exist or is not part of this board" }, :status => :bad_request }
          f.xml  { render :json => { error: "This student does not exist or is not part of this board" }, :status => :bad_request }
        end
      end
    end
end
