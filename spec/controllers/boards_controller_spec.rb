describe BoardsController do
  before :all do
    Board.destroy_all
    @board_hash = Factory.attributes_for :board
  end

  before :each do
    @board = Factory.create :board
    set_api_headers
  end
  
  describe "actions" do
    it "should toggle_active correctly"
  end

  describe "API" do
    it "show" do
      2.times do
        @board.tas.create(Factory.attributes_for :ta)
      end

      5.times do
        @board.students.create((Factory.attributes_for :student).merge({ :in_queue => DateTime.now }))
      end

      authenticate @board.tas.first

      get :show, { :id => @board.title } 
      response.code.should == "200"

      res_hash = decode response.body

      res_hash.count.should == 5

      res_hash['title'].should == @board.title
      res_hash['active'].to_s.should == @board.active.to_s
      res_hash['frozen'].to_s.should == @board.frozen.to_s
      res_hash['students'].count.should == @board.students.in_queue.count
      res_hash['tas'].count.should == @board.tas.count
    end
  end

  describe "API error messages" do

  end

  describe "CRUD" do
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

    end

    it "successfully reads boards"

    it "successfullyy reads board"

    it "successfully destroys board"
  end

end
