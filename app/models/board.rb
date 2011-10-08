class Board
  include Mongoid::Document

  field :title, type: String
  field :password, type: String
  field :frozen, type: Boolean, default: false
  field :active, type: Boolean, default: false

  before_create :create_queue

  has_many :students, dependent: :destroy
  has_many :tas, dependent: :destroy
  has_one :queue, class_name: "BoardQueue", dependent: :destroy

  validates :title, :uniqueness => true
  validates :title, :format => { :with => /^[a-zA-Z_\-0-9]*$/, :message => "The title of a queue must contain only numbers, letters, _, and -"}

  def state
    hash = Hash.new
    hash[:active] = active
    hash[:frozen] = frozen
    hash[:title] = self.title
    hash[:tas] = self.tas
    hash[:students] = self.students
    hash[:queue] = self.queue.as_json
    hash
  end

  def as_json options = {}
    state
  end
  
  def queue_users
    QueueUser.where(:board_id => self.id)
  end

  def to_xml options = {}
    state.to_xml
  end

  def to_param
    self.title
  end
end
