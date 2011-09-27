class Student < QueueUser
  belongs_to :queue_student, polymorphic: true
  field :in_queue, type: DateTime

  validates :location, :presence => true

  scope :in_queue, where(:in_queue.ne => nil)

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:location] = location
    hash[:in_queue] = (in_queue.nil? ? false : true)
    hash
  end
end
