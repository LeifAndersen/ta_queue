describe BoardsController do

  before :all do
    Board.destroy_all
    @board_hash = Factory.attributes_for :board
  end

  before :each do
    @board = Factory.create :board
    @board.active = true
    @board.save
    set_api_headers
  end

  after :each do
    @board.destroy
  end
  
  describe "actions" do
    it "should remove users from queue when going inactive" do
      ta = @board.tas.create!(Factory.attributes_for(:ta))
      @board.active.should == true

      authenticate ta

      5.times do
        @board.students.create!(Factory.attributes_for(:student).merge( :in_queue => DateTime.now ))
      end

      get :show, { :id => @board.title }

      response.code.should == "200"

      res = decode response.body

      res['queue']['students'].count.should == 5

      put :update, { :id => @board.title, :board => { :active => false } }

      response.code.should == "200"

      get :show, { :id => @board.title }

      response.code.should == "200"

      res = decode response.body

      res['queue']['students'].count.should == 0

    end
  end

  describe "API responses" do
    it "index" do
      boards = [@board]

      5.times do
        boards << Factory.create(:board)
      end

      get :index

      response.code.should == "200"

      res_hash = decode response.body

      res_hash.count.should == 6

      for board in res_hash
        board.count.should == 6
        board['title'].should_not be_nil
        board['frozen'].should_not be_nil
        board['active'].should_not be_nil
        board['students'].should_not be_nil
        board['tas'].should_not be_nil
        board['queue'].should_not be_nil
      end
    end

    it "show" do
      2.times do
        @board.tas.create(Factory.attributes_for :ta)
      end

      5.times do
        @board.students.create((Factory.attributes_for :student).merge({ :in_queue => DateTime.now }))
      end

      student = @board.students.first
      student.in_queue = false
      student.save

      authenticate @board.tas.first

      get :show, { :id => @board.title } 

      response.code.should == "200"

      res_hash = decode response.body

      res_hash.count.should == 6

      res_hash['title'].should == @board.title
      res_hash['active'].to_s.should == @board.active.to_s
      res_hash['frozen'].to_s.should == @board.frozen.to_s
      res_hash['students'].count.should == @board.students.count
      res_hash['tas'].count.should == @board.tas.count
      res_hash['queue'].should_not be_nil
      res_hash['queue']['tas'].count.should == @board.tas.count
      res_hash['queue']['students'].count.should == @board.students.in_queue.count
    end

    it "update" do
      ta = @board.tas.create!(Factory.attributes_for(:ta))
      authenticate ta

      @board.active.should == true

      put :update, { :id => @board.title, :board => { :active => true } }

      response.code.should == "200"

      res = decode response.body

      res.should be_empty
    end

  end

  describe "API error messages" do

  end

  describe "CRUD" do

    before :each do
      @ta = @board.tas.create!(Factory.attributes_for :ta)
    end

    it "successfully creates board" do
      # Hold off on these until we're sure we want the web client to be able to
      # create queues
=begin
      post :create, { :master_password => "create_queue", :board => @board_hash }

      response.code.should == "201"

      res_hash = decode response.body

      res_hash.count.should == 2

      res_hash["title"].should == @board_hash[:title]

      res_hash["password"].should == @board_hash[:password]
=end
    end

    it "successfully updates board" do
      authenticate @ta
      @board.active.should == true
      put :update, { :id => @board.title, :board => { :active => false } }

      response.code.should == "200"
      @board = Board.find(@board.id)
      @board.active.should == false
    end

  end

  describe "authentication" do
    before :all do
      @board_auth = Factory.create :board
      @board_auth.students.destroy_all
      @board_auth.tas.destroy_all
      @student = @board_auth.students.create!(Factory.attributes_for(:student))
      @ta = @board_auth.tas.create!(Factory.attributes_for(:ta))
    end

    it "index succeeds with both authentication" do
      get :index

      response.code.should == "200"

      authenticate @ta


      get :index

      response.code.should == "200"

      authenticate @student

      get :index

      response.code.should == "200"
    end

    it "show should fail with no authentication" do
      get :show, { :id => @board_auth.title }

      response.code.should == "401"

      res = decode response.body

      res['error'].should_not be_nil


    end

    it "show should succeed with ta authentication" do
      authenticate @ta

      get :show, { :id => @board_auth.title }

      response.code.should == "200"
    end

    it "show should succeed with student authentication" do
      authenticate @student

      get :show, { :id => @board_auth.title }

      response.code.should == "200"

    end
    
  end

end
