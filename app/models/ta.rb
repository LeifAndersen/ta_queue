class Ta < QueueUser
  belongs_to :board

  has_one :student, :class_name => "Student", dependent: :nullify

  def output_hash
    hash = {}
    hash[:id] = id
    hash[:username] = username
    hash[:student] = self.student.nil? ? nil : self.student.username;
    hash
  end

  def self.create_mock options = {}
    Ta.create!(:username => "Stanley", :token => SecureRandom.uuid)
  end

  def accept_student stud
    unless self.student.nil?
      temp = self.student
      temp.ta = nil
      temp.save
      self.save
    end
      self.student = stud
  end

  def accept_student! stud
    accept_student stud
    save
  end

end
