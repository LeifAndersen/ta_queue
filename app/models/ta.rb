class Ta < QueueUser
  belongs_to :board

  has_one :student, :class_name => "Student", dependent: :nullify

  field :status, type: String, default: ""
  attr_accessor :password

  validate :check_password, :on => :create
  validates :username, :uniqueness => true

  def output_hash
    hash = {}
    hash[:id] = id.to_s
    hash[:username] = username
    hash[:student] = self.student
    hash[:status] = self.status
    hash
  end

  def self.create_mock options = {}
    Ta.create!(:username => "Stanley", :token => SecureRandom.uuid)
  end

  def accept_student stud
    unless self.student.nil?
      prev_student = self.student
      prev_student.exit_queue!
      self.save
    end
      self.student = stud
  end

  def accept_student! stud
    accept_student stud
    save
  end

  private

    def check_password
      if self.password != self.board.password
        self.errors["password"] = "is invalid"
      end
    end
end
