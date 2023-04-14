class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :lockable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo
  has_one :couch, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :couch
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy

  has_many :messages
  has_many :notifications, dependent: :destroy, as: :recipient
  has_many :chat_users
  has_many :chats, through: :chat_users
  has_many :user_characteristics, dependent: :destroy
  has_many :characteristics, through: :user_characteristics

  validates :photo, presence: { message: 'Please upload a picture' }
  validates :first_name, presence: { message: 'First name required' }
  validates :last_name, presence: { message: 'Last name required' }
  validates :date_of_birth, presence: { message: 'Please provide your age' }
  validates :city, presence: { message: 'City required'}
  validates :country, presence: { message: 'Country required'}
  validates :summary, presence: { message: 'Tell the community about you' },
                      length: { minimum: 50, message: 'Tell us more about you (minimum 50 characters)' }
  validates :characteristics, presence: { message: 'Let others know what is important to you' }
  validate  :validate_age
  validate  :validate_travelling

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?
  before_create :generate_invite_code

  def calculated_age
    today = Date.today
    if today.month > date_of_birth.month || (today.month == date_of_birth.month && today.day >= date_of_birth.day)
      calculation = 0
    else
      calculation = 1
    end
    today.year - date_of_birth.year - calculation
  end

  def validate_age
    if calculated_age.present? && calculated_age < 18
      errors.add(:date_of_birth, 'Sorry you are too young, please come back when you are 18!')
    end
  end

  def at_least_one_option_checked?
    offers_couch || offers_co_work || offers_hang_out || travelling
  end

  def validate_travelling
    unless at_least_one_option_checked?
      errors.add(:travelling, 'at least one option must be checked')
    end
  end

  def generate_invite_code
    loop do
      new_invite_code = SecureRandom.hex(3)

      # Check if the generated invite code already exists in the database
      # If not, set it as the user's invite code and break out of the loop
      unless User.exists?(invite_code: new_invite_code)
        self.invite_code = new_invite_code
        break
      end
    end
  end
end
