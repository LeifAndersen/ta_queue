class Student < QueueUser
  belongs_to :board
  belongs_to :ta, :class_name => "Ta"

  field :in_queue, type: DateTime

  validates :location, :presence => true

  scope :in_queue, where(:in_queue.ne => nil, :ta_id => nil).desc(:in_queue)

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:location] = location
    hash[:in_queue] = (in_queue.nil? ? false : true)
    hash
  end
end
