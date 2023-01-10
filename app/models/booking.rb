class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_many :booking_payments
  has_many :payments, through: :booking_payments
  has_one :review

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :date_in_future?, on: :create
  validate :valid_dates?, on: :create
  validate :matches_capacity?
  validate :duplicate_booking?, on: :create
  validate :duplicate_request?, on: :create

  enum status: { pending: 0, confirmed: 1, declined: 2, pending_reconfirmation: 3, completed: 4, cancelled: -1 }

  def date_in_future?
    if Date.yesterday > start_date
      errors.add(:start_date, "Booking can't be in the past")
    end
  end

  def valid_dates?
    if start_date.after? end_date
      errors.add(:start_date, "Dates not valid")
    end
  end

  def matches_capacity?
    if number_travellers > self.couch.capacity
      errors.add(:number_travellers, "The couch you requested can't host that many people")
    end
  end

  def duplicate_booking?
    if Booking.where(couch: self.couch, start_date: self.start_date, end_date: self.end_date, status: 1).exists?
      errors.add(:start_date, "Sorry, the couch is already booked for the dates you requested")
    end
  end

  def duplicate_request?
    if Booking.where(user: self.user, couch: self.couch, start_date: self.start_date, end_date: self.end_date, status: 0 || 2).exists?
      errors.add(:start_date, "Sorry, you already sent a request to this host for the same dates")
    end
  end

  def self.complete
		completed_bookings = Booking.where(end_date: ...Date.today, status: 1)
    completed_bookings.update(status: 4)
    completed_bookings.each do |booking|
      BookingMailer.with(booking: booking).booking_completed_guest_email.deliver_later
      BookingMailer.with(booking: booking).booking_completed_host_email.deliver_later
    end
	end

  def month
    start_date.strftime("%B")
  end

  def year
    start_date.year
  end
end
