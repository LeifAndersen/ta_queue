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

end
