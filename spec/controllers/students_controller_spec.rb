require 'spec_helper'

describe StudentsController do

    before :all do
      Board.destroy_all
      Student.destroy_all 
      @board = Board.create!(:title => "CS1410", :password => "some_password")
      @full_student_hash = { :username => "Bob", :location => "some_place" }
    end

    after :all do
      @board.destroy
    end

    before :each do
      #@full_student = Student.create!(:username => "Bob", :token => SecureRandom.uuid, :location => "some_place")
      set_api_headers
    end

  it "fails when student tries to change another student's state"

  describe "CRUD student" do
    it "successfully creates a student" do
      post :create, { :student => @full_student_hash, :board_id => @board.title }

      response.code.should == "201"

      res_hash = ActiveSupport::JSON.decode(response.body)

      res_hash.count.should == 4

      res_hash['username'].should == @full_student_hash[:username]
      res_hash['location'].should == @full_student_hash[:location]
      res_hash['id'].should_not be_nil
      res_hash['token'].should_not be_nil

      @full_student_hash.merge!({ :id => res_hash['id'], :token => res_hash['token']})
    end

    it "successfully reads a student" do
      authenticate QueueUser.where(:_id => @full_student_hash[:id]).first
      get :show, { :id => @full_student_hash[:id], :board_id => @board.title }

      response.code.should == "200"

      res_hash = ActiveSupport::JSON.decode(response.body)

      res_hash.count.should == 4

      res_hash['username'].should == @full_student_hash[:username]
      res_hash['location'].should == @full_student_hash[:location]
      res_hash['id'].should == @full_student_hash[:id]
      res_hash['in_queue'].to_s.should == "false"
    end

    it "fails reading a student w/o credentials" do
      get :show, { :id => @full_student_hash[:id], :board_id => @board.title }

      response.code.should == "401"
    end

    it "successfully updates the student's in_queue" do
      authenticate QueueUser.where(:_id => @full_student_hash[:id]).first
      put :update, { :student => { :in_queue => true}, :id => @full_student_hash[:id], :board_id => @board.title }
      response.code.should ==  "200"

      res_hash = ActiveSupport::JSON.decode(response.body)
      res_hash.count.should == 4
      res_hash['in_queue'].to_s.should == "true"
    end

    it "fails updating w/o credentials" do
      put :update, { :student => { :in_queue => true}, :id => @full_student_hash[:id], :board_id => @board.title }
      response.code.should ==  "401"
    end

    it "fails destroying without authorization" do
      delete :destroy, { :board_id => @board.title, :id => @full_student_hash[:id] }
      response.code.should == "401"
    end

    it "successfully destroys the student" do
      authenticate QueueUser.where(:_id => @full_student_hash[:id]).first
      delete :destroy, { :board_id => @board.title, :id => @full_student_hash[:id] }

      response.code.should == "200"

      QueueUser.where(:_id => @full_student_hash[:id]).first.should be_nil
    end
  end

  describe "student actions" do
    before :all do
      @ta = Ta.create_mock
    end

    it "should accept student" do
      authenticate @ta 

    end
  end
end
