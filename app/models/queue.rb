class Queue
  include Mongoid::Document

  belongs_to :class
  has_many :students
  has_many :tas

  def state
    students.to_a + tas.to_array
  end
end
