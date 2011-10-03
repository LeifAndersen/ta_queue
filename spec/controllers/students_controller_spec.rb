require 'spec_helper'

describe StudentsController do
  describe "CREATE student" do

    before :all do
      Board.destroy_all
      Student.destroy_all 
      @board = Board.create!(:title => "CS1410", :password => "some_password")
    end

    after :all do
      @board.destroy
    end

    before :each do
      #@full_student = Student.create!(:username => "Bob", :token => SecureRandom.uuid, :location => "some_place")
      @full_student_hash = { :username => "Bob", :location => "some_place" }
      set_api_headers
    end

    def authenticate user
      request.env['Authorization'] = ActionController::HttpAuthentication::Basic.encode_credentials(user.id, user.token)
    end

    def set_api_headers
      request.env['HTTP_ACCEPT'] = "application/json"
      request.env['HTTP_CONTENT_TYPE'] = "application/json"
    end
    
    it "should succeed with proper credentials" do
      #authenticate @full_student
      post :create, { :student => @full_student_hash, :board_id => @board.title }

      response.code.should == "201"

      res_hash = ActiveSupport::JSON.decode(response.body)

      res_hash.count.should == 4

      res_hash['username'].should == @full_student_hash[:username]
      res_hash['location'].should == @full_student_hash[:location]
      res_hash['id'].should_not be_nil
      res_hash['token'].should_not be_nil
    end
  end
end
