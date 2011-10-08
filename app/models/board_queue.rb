class BoardQueue
  include Mongoid::Document

  belongs_to :board
  field :frozen, type: Boolean, default: false

  # Not currently a proper association for students in the queue or not,
  # students have a boolean that determines that

  def state
    hash = {}
    hash[:frozen] = self.frozen
    hash[:students] = self.students.as_json
    hash[:tas] = self.tas.as_json
    hash
  end

  def as_json
    state
  end

  def students
    self.board.students.in_queue
  end

  def tas
    self.board.students.in_queue
  end

end
