class ApplicationController < ActionController::Base
  protect_from_forgery

  #before_filter :authorize!

  private

    def current_user
      @current_user
    end

    # Simply grabs the user using the HTTP Credentials, does NOT redirect due to multiple redirects
    # being called if it happens here
    def authorize!
      if request.format != "html"
        @current_user ||= authenticate_with_http_basic do |u, p| logger.debug "CREDENTIALS: " + u.to_s + " " + p.to_s; QueueUser.where(:_id => u, :token => p).first end

      else
        @current_user ||= QueueUser.where(:_id => session['user_id']).first
      end

      if @current_user
        keep_alive @current_user
      end
    end

    def authenticate!
      authorize!
      if current_user.nil?
        respond_with do |f|
          f.json { render :json => { :error => "You are not authorized to perform this action" }, :status => :unauthorized }
        end
      end
    end


    def get_board
      if params[:controller] == "boards"
        @board ||= Board.where(:title => params[:id]).first
      else
        @board ||= Board.where(:title => params[:board_id]).first
      end
    end

    def authenticate_student! options = {}
      authorize!
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

    def authenticate_current_student!
      authenticate_student! current: true
    end

    def authenticate_current_student_or_ta!
      authorize!
      unless current_user && current_user.ta?
        authenticate_current_student!
      end
    end

    def authenticate_ta! options = {}
      authorize!
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

    # Makes sure that users that are making requests often are "kept alive" so the
    # crom task doesn't wipe them out.
    def keep_alive user
      if user.alive_time.nil?
        user.alive_time = DateTime.now
        user.save
        logger.debug "Alive time updated"
      else
        if user.alive_time + 15.minutes < DateTime.now
          user.alive_time = DateTime.now
          user.save
          logger.debug "Alive time updated"
        end
      end
    end

end
