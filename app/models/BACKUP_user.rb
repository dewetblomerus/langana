class User < ActiveRecord::Base
  before_save :encrypt_mobile_confirmation_code
  before_validation :format_mobile_number
  attr_accessor :mobile_confirmation_code
  has_secure_password

  has_many :work_references_written, class_name: 'WorkReference', foreign_key: :employer_user_id

  mount_uploader :profile_picture, ProfilePictureUploader

  enum role: [:employer, :vip, :admin]
  enum gender: [:male, :female]

  validates_presence_of :first_name, :last_name, :mobile_number

  validates :mobile_number, presence: true,
                            length: { minimum: 12, maximum: 12, allow_blank: false },
                            format: /\+\d{11}\z/,
                            uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 6, allow_blank: true }

  CITIES = [
    'Cape Town'].freeze

  scope :confirmed, -> { where('confirmed_at IS NOT NULL').order(first_name: :asc) }
  scope :employers, -> { where('role = ?', 0) }

  def encrypt_mobile_confirmation_code
    if mobile_confirmation_code.present?
      self.mobile_code_salt = BCrypt::Engine.generate_salt
      self.mobile_confirmation_code_digest = BCrypt::Engine.hash_secret(mobile_confirmation_code, mobile_code_salt)
    end
  end

  def self.authenticate(mobile_number, password)
    mobile_number = ApplicationHelper.format_mobile(mobile_number)
    user = User.find_by(mobile_number: mobile_number)
    user && user.authenticate(password)
  end

  def format_mobile_number
    self.mobile_number = ApplicationHelper.format_mobile(mobile_number)
  end
end
