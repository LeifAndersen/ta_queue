class ApplicationController < ActionController::Base
  protect_from_forgery

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

end
