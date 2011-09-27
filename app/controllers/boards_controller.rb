class BoardsController < ApplicationController
  respond_to :xml, :json, :html
  before_filter :get_board, :except => [:new, :create, :index]
  before_filter :authorize_ta!, :only => [:update]
  before_filter :filter_users, :only => [:login, :login_user]
  before_filter :filter_master_password => [:create]

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

    respond_with do |f|
      if @board.save
        f.html { redirect_to board_login_path(@board) }
        f.json { render :json => @board.state }
        f.xml  { render :json => @board.state }
      else
        f.html { render :edit }
        f.json { render :json => @board.errors, :status => :unprocessable_entity }
        f.xml  { render :json => @board.errors, :status => :unprocessable_entity }
      end
    end
  end

  def new
    @board = Board.new
  end

  def index
    @boards = Board.all
  end

  def show
    @current_user = QueueUser.where(:_id => session['user_id']).first
    if @current_user.nil?
      if session['user_id']
        session.delete 'user_id'
      end
      redirect_to board_login_path(@board) and return
    end
    respond_with do |format|
      format.html { render :show }#render :json => @board.state }
      format.json { render :json => @board.state }
    end
  end

  def login
  end

  def logout
    if request.format == "html"
      user_id = session['user_id']
      session.delete 'user_id'
    else
      user_id = params[:id]
    end

    @user = QueueUser.where(:_id => user_id).first

    respond_with do |f|
      if @user
        @user.destroy
      end
        f.html { redirect_to board_login_path }
        f.json { render head, :status => :success }
    end
  end

  def login_user

    if params[:ta_password].present?
      if params[:ta_password] != @board.password
        flash[:errors] = ["Invalid password for this TA Board"]
        redirect_to board_login_path and return
      end
      @user = @board.tas.new(:username => params[:ta_name], :token => SecureRandom.uuid)
    else
      @user = @board.students.new(:username => params[:student_name], :location => params[:location], :token => SecureRandom.uuid)
    end

    if request.format == "html"
      session['user_id'] = @user.id.to_s
    end 

    respond_with do |f|
      if @user.save
        f.html { redirect_to @board }
        f.json { render :json => { :id => @user.id, :token => @user.token } }
      else
        flash[:errors] = @user.errors.full_messages
        f.html { redirect_to board_login_path(@board) }
        f.json { render head, :status => :unprocessible_entity }
      end
    end
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

    def filter_master_password
    end

end
