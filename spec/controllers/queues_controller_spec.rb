require 'spec_helper'

describe QueuesController do
  before :all do
  end

  after :all do
  end

  before :each do
    @board = Factory.create :board
    @queue = @board.queue
    @ta = @board.tas.create!(Factory.attributes_for(:ta))
    @student = @board.students.create!(Factory.attributes_for(:student))
    @student.in_queue = nil
    @student.save
    set_api_headers
  end

  after :each do
    @student.destroy
    @ta.destroy
    @board.destroy
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
      3.times do
        @board.tas.create!(Factory.attributes_for(:ta))
      end

      5.times do
        @board.students.create!(Factory.attributes_for(:student))
      end

      7.times do
        @board.students.create!(Factory.attributes_for(:student).merge!( :in_queue => DateTime.now ))
      end

      get :show, { :board_id => @board.title }

      response.code.should == "200"
      
      res_hash = decode response.body


      res_hash.count.should == 4

      res_hash['frozen'].should_not be_nil
      res_hash['active'].should_not be_nil
      res_hash['students'].should_not be_nil
      res_hash['tas'].should_not be_nil

      res_hash['students'].count.should == 7
      res_hash['tas'].count.should == 4 # the extra is due to the ta created in the before :each block
    end

    it "students should come back in the order they joined the queue" do
      @board.students.destroy_all
      @board.tas.destroy_all

      time = DateTime.now
      # Order shoudl be 2, 5, 0, 1, 3, 4
      order = {}

      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time + 2.seconds ))
      order["2"] = stud.id.to_s
      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time + 3.seconds ))
      order["3"] = stud.id.to_s
      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time ))
      order["0"] = stud.id.to_s
      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time + 4.seconds ))
      order["4"] = stud.id.to_s
      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time + 5.seconds ))
      order["5"] = stud.id.to_s
      stud = @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => time + 1.second  ))
      order["1"] = stud.id.to_s

      get :show, { :board_id => @board.title }

      response.code.should == "200"
      
      res = decode response.body

      res['students'].count.should == 6

      @board = Board.where(:title => @board.title).first
      students = @board.queue.students.to_a

      students.each_index do |i|
        students[i].id.to_s.should == order[i.to_s].to_s
      end

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

  end

  describe "Error validation" do
    it "receives proper validation errors" do
      authenticate @student
      authenticate @ta

      @queue.frozen = false
      @queue.save

      put :update, { :board_id => @board.title, :queue => { :frozen => "hello" } }

      response.code.should == "422"

      res = decode response.body

      res['frozen'].should_not be_nil
    end

    it "Doesn't respond to enter_queue when frozen" do
      queue = @board.queue
      queue.frozen = true
      queue.save

      authenticate @student

      get :enter_queue, { :board_id => @board.title }

      response.code.should == "403"

      res = decode response.body

      res['error'].should_not be_nil
      @student = Student.find(@student.id)
      @student.in_queue.should == nil
    end
  end
end
