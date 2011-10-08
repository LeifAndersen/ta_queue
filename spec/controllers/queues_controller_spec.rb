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
    it "show" do
      get :show, { :board_id => @board.title }
    end

    it "update"

  end

  describe "actions" do
    it "should allow student to enter queue" do
      authenticate @student
      get :enter_queue, { :board_id => @board.title }

      response.code.should == "200" 
      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should_not be_nil
      res_hash['queue']['students'][0]['username'].should == student.username
    end

    it "should allow student to exit queue" do
      authenticate @student
      get :exit_queue, { :board_id => @board.title }

      response.code.should == "200"

      res_hash = decode response.body

      student = Student.find(@student.id)

      student.in_queue.should be_nil

      res_hash['queue']['students'].should be_empty
    end

    it "receives proper validation errors"

  end
end
