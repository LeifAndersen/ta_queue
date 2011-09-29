class TasController < ApplicationController
  before_filter :get_board
  before_filter :get_ta, :except => [:new, :create, :index]
  before_filter :authorize_ta!, :except => [:create]

  respond_to :json, :xml

  def show
    respond_with @ta
  end

  def create 
    @ta = @board.tas.new(params[:ta].merge( { token: SecureRandom.uuid } ) )

    respond_with do |f|
      if @ta.save
        session['user_id'] = @ta.id if request.format == 'html'
        f.html { redirect_to board_path @board }
        f.json { render :json => { token: @ta.token, id: @ta.id, username: @ta.username } }
        f.xml  { render :xml => { token: @ta.token, id: @ta.id, username: @ta.username } }
      else
        f.html { redirect_to board_login_path @board }
        f.json { render :json => @ta.errors, :status => :unprocessable_entity }
        f.json { render :xml => @ta.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @ta.update_attributes(params[:ta])
    if params[:accept_student] != nil
      unless @ta.student.nil?
        student = @ta.student
        student.in_queue = false unless @ta.student.nil?
        student.save
      end
      @ta.student = nil
      @ta.student = @board.students.where(:_id => params[:accept_student]).first
    end
    @ta.save

    respond_with @ta
  end

  def destroy
    @ta.destroy
    respond_with do |f|
      f.html { redirect_to board_login_path @board }
    end
  end

  private

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
end
