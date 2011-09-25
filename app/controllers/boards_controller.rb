class BoardsController < ApplicationController
  respond_to :xml, :json, :html
  before_filter :get_board

  def show
    @ta_signed_in = true
    @student_signed_in = false
    @current_user = Ta.find(session["ta_id"])
    respond_with do |format|
      format.html { render :show }#render :json => @board.state }
      format.json { render :json => @board.state }
    end
  end

  def login

  end

  def login_user
    @user = @board.tas.create!(:username => params[:username], :token => SecureRandom.uuid)

    session[:ta_id] = @user.id.to_s

    respond_with do |f|
      #format.html { redirect_to @board }
      f.html { render :json => { :id => @user.id, :token => @user.token } }
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

end
