class Student < QueueUser
  belongs_to :board
  belongs_to :ta, :class_name => "Ta"

  field :in_queue, type: DateTime

  validates :location, :presence => true

  scope :in_queue, where(:in_queue.ne => nil, :ta_id => nil).asc(:in_queue)

  def output_hash
    hash = {}
    hash[:id] = id.to_s
    hash[:username] = username
    hash[:location] = location
    hash[:in_queue] = (in_queue.nil? ? false : true)
    hash
  end

  def enter_queue
    if self.in_queue.nil?
      self.in_queue = DateTime.now
    end
  end

  def enter_queue!
    enter_queue
    save
  end

  def exit_queue
    unless self.in_queue.nil?
      self.in_queue = nil
      unless self.ta.nil?
        self.ta = nil
      end
    end
  end

  def exit_queue!
    exit_queue
    save
  end

end
