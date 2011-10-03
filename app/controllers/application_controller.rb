class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_filter :authorize!

  def authorize_ta!
      if session['user_id'] != @ta.id
        if params[:token].nil? || @ta.token != params[:token]
          respond_with do |f| 
            f.json { head :forbidden }
            f.xml  { head :forbidden }
          end
          return
        end
      end
  end

  def get_ta
    @ta ||= @board.tas.where(:_id => params[:id]).first
    if !@ta
      respond_with do |f|
        f.json { head :bad_request }
        f.xml { head :bad_request }
      end
    end
  end

  def current_user
    @current_user
  end

  private

    def authorize!
      if request.format != "html"
        @current_user = authenticate_with_http_basic do |u, p| QueueUser.where(:_id => u, :token => p) end
      end
    end

    def authenticate_student! options = {}
      if options[:current] == true
        unless current_user and current_user.student? and QueueUser.where(:_id => params[:id]).first == current_user
          send_head_with :unauthorized and return
        end
      else
        unless current_user and current_user.student?
          send_head_with :unauthorized and return
        end
      end
    end

    def authenticate_ta! options = {}
      if options[:current] == true
        unless current_user and current_user.ta? and QueueUser.where(:_id => params[:id]).first == current_user
          send_head_with :unauthorized and return
        end
      else
        unless current_user and current_user.ta?
          send_head_with :unauthorized and return
        end
      end
    end

    def send_head_with symbol
      respond_with do |f|
        f.html { redirect_to root_path, :notice => "You are not authorized to access this page" }
        f.json { head symbol }
        f.xml  { head symbol }
      end
    end

end
