require 'spec_helper'

describe QueuesController do

  describe "actions" do
    before :all do
      @board = Board.create!(:title => "BoardTitle", :password => "Some password")
      @ta = @board.tas.create!(:username => "parker", :token => SecureRandom.uuid)
      @student = @board.students.create!(:username => "parker student", :location => "somewhere", :token => SecureRandom.uuid)
      @student.in_queue = nil
      @student.save
    end

    after :all do
      @student.destroy
      @ta.destroy
      @board.destroy
    end

    before :each do
      set_api_headers
    end

    it "should allow ta to enter queue" do
      authenticate @student
      get :enter_queue, { :board_id => @board.title }

      response.code.should == "200" 
      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should_not be_nil
      res_hash['students'][0]['username'].should == student.username
    end

    it "should allow ta to exit queue" do
      authenticate @student
      get :exit_queue, { :board_id => @board.title }

      response.code.should == "200"

      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should be_nil

      res_hash['students'].should be_empty
    end

  end
end
