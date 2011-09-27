class TasController < ApplicationController
  before_filter :get_board
  before_filter :get_ta
  before_filter :authorize_ta!, :only => [:create]

  respond_to :json, :xml

  def show
    respond_with do |f|
      f.json{ render :json => @ta.output_hash }
      f.xml { render :xml => @ta.output_hash }
    end
  end

  # NOTE: DOES NOT CREATE OBJECT, UPDATES OBJECT
  def create 
    if params[:logout]
      @ta.destroy
      respond_with do |f|
        f.json { head :success }
        f.xml  { head :success }
      end
      return
    end

    if params[:location]
      @ta.location = params[:location]
    end

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
