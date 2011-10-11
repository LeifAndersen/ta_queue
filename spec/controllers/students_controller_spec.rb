require 'spec_helper'

describe StudentsController do

  before :each do
    set_api_headers
  end

  it "fails when student tries to change another student's state" do
    @student_1 = Factory.create :student
    @student_2 = Factory.create :student
    authenticate @student_2

    put :update, { :student => { :username => "it doesn't matter cause this should fail" }, :board_id => @board.title, :id => @student_1.id.to_s }

    response.code.should == "401"
  end

    before :all do
      Board.destroy_all
      Student.destroy_all 
      @board = Factory :board
      @full_student_hash = Factory.attributes_for :student
    end

    after :all do
      @board.destroy
    end

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

    it "receives proper validation errors" do
    	post :create, { :student => @full_student_hash, :username => "", :board_id => @board.title }
    	
    	response.code.should == "422"
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

  describe "API content" do
    
    it "returns proper average-case in JSON"

    it "orders students in the order they join the queue"

  end

  describe "student actions" do
    before :each do
      @full_student_hash = Factory.attributes_for :student
      @ta = @board.tas.create!(Factory.attributes_for :ta )
      @student = @board.students.create!(@full_student_hash)
    end

    after :each do
      Ta.destroy_all
      Student.destroy_all
    end

    it "should successfully be accepted by TA" do
      authenticate @ta 

      @ta.student.should be_nil

      get :ta_accept, { :board_id => @board.title, :id => @student.id }

      response.code.should == "200"

      ta = Ta.find(@ta.id)

      ta.student.should_not be_nil
      ta.student.id.should == @student.id

      @student = Student.find(@student.id)
      @student.ta.should_not be_nil
      @student.ta.id.should == @ta.id
    end

    it "should reject ta_accept from a student" do
      authenticate @student

      get :ta_accept, { :board_id => @board.title, :id => @student.id }

      response.code.should == "401"
    end

    it "should reject ta_accept without authentication" do
      get :ta_accept, { :board_id => @board.title, :id => @student.id }

      response.code.should == "401"
    end

    it "should properly detach the current student when accepting a new student" do
      authenticate @ta

      @ta.student = @student
      @ta.save

      @second_student = @board.students.create!(Factory.attributes_for :student)

      get :ta_accept, { :board_id => @board.title, :id => @second_student.id }

      response.code.should == "200"

      @ta = Ta.find(@ta.id)

      @ta.student.id.should == @second_student.id
    end
  end
end
