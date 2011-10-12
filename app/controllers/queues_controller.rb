class QueuesController < ApplicationController
  before_filter :get_board
  before_filter :get_queue
  before_filter :check_frozen, :only => [:enter_queue]
  before_filter :authenticate_student!, :only => [:enter_queue, :exit_queue]
  before_filter :authenticate!, :only => [:show]
  before_filter :authenticate_ta!, :only => [:update]

  respond_to :json

  def show
    respond_with @queue
  end

  def update
    @queue.update_attributes(params[:queue])
    respond_with @queue
  end

  def enter_queue
    current_user.enter_queue!
    respond_with @queue
  end

  def exit_queue
    current_user.exit_queue!
    respond_with @queue
  end
  
  private

  def get_queue
    @queue = @board.queue
  end

  def check_frozen
    if @queue.frozen
      respond_with do |f|
        f.json { render :json => { :error => "You cannot enter the queue when it is frozen" }, :status => :forbidden }
      end
    end
  end
end
