class BoardsController < ApplicationController
  respond_to :xml, :json, :html
  before_filter :get_queue

  def show
    
    respond_with do |format|
      format.html { render :show }
      format.json { render :json => @board.state }
    end
  end

  private
    def get_queue
      @board = Board.where(:title => params[:id]).first
    end
end
