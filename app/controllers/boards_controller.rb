class BoardsController < ApplicationController
  respond_to :xml, :json, :html
  before_filter :get_board
  before_filter :redirect_if_logged_in, :only => [:login, :login_user]

  def show
    @current_user = User.find(session['user_id'])
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

    @user = User.where(:id => user_id).first
    respond_with do |f|
      if @user
        @user.destroy
      end
        f.html { redirect_to board_login_path }
        f.json { render head, :status => :success }
    end
  end

  def login_user

    if params[:ta_password]
      if params[:ta_password] != @board.password
        flash[:errors] = ["Invalid password for this TA Board"]
        redirect_to board_login_path and return
      end
      @user = @board.tas.new(:username => params[:username], :token => SecureRandom.uuid)
    else
      @user = @board.students.new(:username => params[:username], :location => params[:location], :token => SecureRandom.uuid)
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
        
    end
    def redirect_if_logged_in
      if session["user_id"]
        if User.find(session["user_id"])
          redirect_to @board and return
        else
          session.delete "user_id"
        end
      end
    end

end
