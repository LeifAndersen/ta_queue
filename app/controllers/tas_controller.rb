class TasController < ApplicationController
  before_filter :get_board
  before_filter :get_ta
  before_filter :authorize_ta!, :only => [:create]

  respond_to :json, :xml

  def show
    respond_with @ta
  end

  def create 
    @ta = @board.tas.new(params[:ta].merge( { token: SecureRandom.uuid } ) )

    respond_with do |f|
      if @ta.save
        session['user_id'] = @ta.id if request.format == 'html'
        f.html { redirect_to (board_path @board) }
        f.json { render :json => { token: @ta.token, id: @ta.id, username: @ta.username } }
        f.xml  { render :xml => { token: @ta.token, id: @ta.id, username: @ta.username } }
      else
        raise @student.errors.inspect
        f.html { redirect_to board_login_path @board }
        f.json { render :json => @ta.errors, :status => :unprocessable_entity }
        f.xml  { render :xml => { token: @ta.token, id: @ta.id, username: @ta.username } }
      end
    end
  end

  def update
    if params[:logout]
      @ta.destroy
      respond_with do |f|
        f.json { head :success }
        f.xml  { head :success }
      end
      return
    end

    @ta.current_student = Student.where(params[:ta][:current_student]).first if params[:ta][:current_student]

    respond_with do |f|
      if @ta.save
        f.json { render :json => @ta.output_hash }
        f.xml  { render :json => @ta.output_hash }
      else
        f.json { render :json => @ta.errors, :status => :unprocessable_entity }
        f.xml  { render :json => @ta.errors, :status => :unprocessable_entity }
      end
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
