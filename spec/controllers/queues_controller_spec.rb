require 'spec_helper'

describe QueuesController do
  before :all do
    @board = Factory.create :board
    @ta = @board.tas.create!(Factory.attributes_for(:ta))
    @student = @board.students.create!(Factory.attributes_for(:student))
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

  describe "API" do
    it "update" do
      authenticate @ta

      @board.queue.frozen.should == false

      put :update, { :board_id => @board.title, :queue => { :frozen => true } }

      res = decode response.body

      res.should be_empty

      response.code.should == "200"
    end

    it "show" do
      get :show, { :board_id => @board.title }

      response.code.should == "200"
      
      res_hash = decode response.body


      res_hash.count.should == 3

      res_hash['frozen'].should_not be_nil
      res_hash['students'].should_not be_nil
      res_hash['tas'].should_not be_nil
    end


  end

  describe "actions" do
    it "should allow student to enter queue" do
      authenticate @student
      get :enter_queue, { :board_id => @board.title }

      response.code.should == "200" 
      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should_not be_nil
      res_hash['students'][0]['username'].should == student.username
    end

    it "should allow student to exit queue" do
      authenticate @student
      get :exit_queue, { :board_id => @board.title }

      response.code.should == "200"

      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should be_nil

      res_hash['students'].should be_empty
    end

    it "receives proper validation errors"

    it "Doesn't respond to anything when frozen"

  end
end
