class Booking < ApplicationRecord
  belongs_to :couch
  belongs_to :user
  has_many   :booking_payments
  has_many   :payments, through: :booking_payments
  has_many   :reviews

  validates  :request, presence: { message: 'Please choose one' }
  validates  :start_date, presence: true
  validates  :end_date, presence: true
  validates  :message, presence: true
  validate   :matches_capacity?
  validate   :duplicate_booking?, on: :create
  validate   :duplicate_request?, on: :create

  enum status: { pending: 0, confirmed: 1, declined: 2, pending_reconfirmation: 3, completed: 4, cancelled: -1 }
  enum request: { host: 0, hangout: 1, cowork: 2 }

  def matches_capacity?
    if number_travellers > couch.capacity
      errors.add(:number_travellers, 'Capacity of couch exceeded')
    end
  end

  def duplicate_booking?
    if Booking.where(couch:, start_date:, end_date:, status: 1).exists?
      errors.add(:start_date, 'Sorry, couch is already booked!')
    end
  end

  def duplicate_request?
    if Booking.where(user:, couch:, start_date:, end_date:, status: 0 || 2).exists?
      errors.add(:start_date, 'Duplicate request with host')
    end
  end

  def self.complete
    completed_bookings = Booking.where(end_date: ...Date.today, status: 1)
    completed_bookings.update(status: 4)
    completed_bookings.each do |booking|
      BookingMailer.with(booking:).booking_completed_guest_email.deliver_later
      BookingMailer.with(booking:).booking_completed_host_email.deliver_later
    end
    charge(completed_bookings)
	end

  def self.charge(bookings)
    bookings.each do |booking|
      payment = booking.payments.find_by(operation: 1)
      session = Stripe::Checkout::Session.retrieve(
        id: payment.checkout_session_id,
        expand: ['setup_intent']
      )

      intent = Stripe::PaymentIntent.create(
        customer: session[:customer],
        payment_method: session[:setup_intent].payment_method,
			  description: "Stay with #{booking.couch.user.first_name}",
        amount: booking.nights * 100,
        currency: 'eur',
        metadata: { booking_id: booking.id },
        receipt_email: booking.user.email,
        confirm: true
      )

      payment.update(payment_intent: intent.id, status: 2)
    end
  end

  def self.delete
    pending_bookings = Booking.where(start_date: ...Date.today, status: 0)
    pending_bookings.destroy_all
  end
end
