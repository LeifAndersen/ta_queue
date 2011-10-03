require 'spec_helper'

describe TasController do
    before :all do
      Board.destroy_all
      Student.destroy_all 
      Ta.destroy_all
      @board = Board.create!(:title => "CS1410", :password => "some_password")
      @full_ta_hash = { :username => "Bob" }
    end

    after :all do
      @board.destroy
    end

    before :each do
      #@full_student = Student.create!(:username => "Bob", :token => SecureRandom.uuid, :location => "some_place")
      set_api_headers
    end
  describe "CRUD ta" do
    it "successfully creates a ta" do
      post :create, { :ta => @full_ta_hash, :password => @board.password, :board_id => @board.title }

      response.code.should == "201"

      res_hash = ActiveSupport::JSON.decode(response.body)

      res_hash.count.should == 3

      res_hash['username'].should == @full_ta_hash[:username]
      res_hash['id'].should_not be_nil
      res_hash['token'].should_not be_nil

      @full_ta_hash.merge!({ :id => res_hash['id'], :token => res_hash['token']})
    end

    it "fails to create a ta without proper password" do
      post :create, { :ta => @full_ta_hash, :password => "wrong_password", :board_id => @board.title }

      response.code.should == "401"
    end

    it "successfully reads a ta" do
      authenticate QueueUser.where(:_id => @full_ta_hash[:id]).first
      get :show, { :id => @full_ta_hash[:id], :board_id => @board.title }

      response.code.should == "200"

      res_hash = ActiveSupport::JSON.decode(response.body)

      res_hash.count.should == 3

      res_hash['username'].should == @full_ta_hash[:username]
      res_hash['id'].should == @full_ta_hash[:id]
      res_hash['student'].should be_nil
    end

    it "fails reading a ta w/o credentials" do
      get :show, { :id => @full_ta_hash[:id], :board_id => @board.title }

      response.code.should == "401"
    end

    it "successfully updates username" do
      authenticate QueueUser.where(:_id => @full_ta_hash[:id]).first
      new_username = "Harry"
      put :update, { :ta => { :username => new_username }, :id => @full_ta_hash[:id], :board_id => @board.title }

      response.code.should == "200"

      res_hash = ActiveSupport::JSON.decode(response.body)
      res_hash.count.should == 3

      res_hash['username'].should == new_username
    end

    it "fails updating w/o credentials" do
      put :update, { :student => { :in_queue => true}, :id => @full_ta_hash[:id], :board_id => @board.title }
      response.code.should ==  "401"
    end

    it "fails destroying without authorization" do
      delete :destroy, { :board_id => @board.title, :id => @full_ta_hash[:id] }

      response.code.should == "401"
    end

    it "successfully destroys the student" do
      authenticate QueueUser.where(:_id => @full_ta_hash[:id]).first
      delete :destroy, { :board_id => @board.title, :id => @full_ta_hash[:id] }

      response.code.should == "200"

      QueueUser.where(:_id => @full_ta_hash[:id]).first.should be_nil
    end
  end
end

