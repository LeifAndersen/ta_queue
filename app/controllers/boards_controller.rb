class BoardsController < ApplicationController
  respond_to :xml, :json, :html
  before_filter :get_board, :except => [:new, :create, :index]
  before_filter :authenticate_ta!, :only => [:update]
  before_filter :authenticate_user_for_current_board!, :only => [:show]
  before_filter :filter_users, :only => [:login, :login_user]

  def create
    if params[:master_password] == "create_queue"
      @board = Board.new(params[:board])
      @board.frozen = false
      @board.active = false

      if @board.save
        redirect_to board_login_path(@board)
      else
        render :new
      end
    else
      flash[:error] = "Invalid master password"
      redirect_to new_board_path
    end
  end

  def update
    @board.update_attributes(params[:board])

    respond_with @board
  end

  def new
    @board = Board.new
  end

  def index
    @boards = Board.all
    respond_with @boards
  end

  def show
    respond_with @board
  end

  def login
    @ta = Ta.new
    @student = Student.new    
  end

  private

    def get_board
      if params[:id]
        @board = Board.where(:title => params[:id]).first
      else
        @board = Board.where(:title => params[:board_id]).first
      end

      if @board.nil?
        redirect_to root_path
      end
        
    end

    def filter_users
      if session["user_id"]
        if QueueUser.where(:_id => session["user_id"]).first
          redirect_to @board and return
        else
          session.delete "user_id"
        end
      end
    end

    def authenticate_user_for_current_board!
      authorize!
      unless current_user && @board.queue_users.where(:_id => current_user.id).first
        respond_with do |f|
          f.html { redirect_to board_login_path @board }
          f.json { render :json => { :error => "You are not authorized to access this board" }, :status => :unauthorized }
          f.xml  { render :json => { :error => "You are not authorized to access this board" }, :status => :unauthorized }
        end
      end
    end

end
