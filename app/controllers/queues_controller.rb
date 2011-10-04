class QueuesController < ApplicationController
  before_filter :get_board
  before_filter :authenticate_student!, :only => [:enter_queue, :exit_queue]
  before_filter :authenticate_ta!, :only => [:update]

  respond_to :json

  def show

  end

  def update

  end

  def enter_queue
    current_user.enter_queue!
    respond_with @board, :include => [:tas, :students]
  end

  def exit_queue
    current_user.exit_queue!
    respond_with @board, :include => [:tas, :students]
  end
  
  private
end
