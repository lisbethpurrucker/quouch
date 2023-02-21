class Couch < ApplicationRecord
  include PgSearch::Model

  belongs_to :user
  has_one :city, through: :user
  has_one :country, through: :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :couch_facilities, dependent: :destroy, autosave: true
  accepts_nested_attributes_for :couch_facilities
  has_many :facilities, through: :couch_facilities

  pg_search_scope :search_by_city_or_country, associated_against: {
    city: :name,
    country: :name
  }
end
