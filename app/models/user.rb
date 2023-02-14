class User < ApplicationRecord
  acts_as_token_authenticatable

  # Include default devise modules. Others available are:
  # , :lockable, :timeoutable, :trackable and :omniauthable, :confirmable  
  devise :invitable, :database_authenticatable, :registerable,
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

  belongs_to :city, optional: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :date_of_birth, presence: true
  validate :validate_age

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  def calculated_age
    today = Date.today
    if today.month > date_of_birth.month || (today.month == date_of_birth.month && today.day >= date_of_birth.day)
      calculation = 0
    else
      calculation = 1
    end
    return today.year - date_of_birth.year - calculation
  end

  def validate_age
    if calculated_age.present? && calculated_age < 18
      errors.add(:date_of_birth, 'Sorry, come back when you are 18!')
    end
  end

  def full_name
    return first_name + last_name
  end
end
