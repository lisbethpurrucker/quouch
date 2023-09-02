class StatisticsMailer < ApplicationMailer
	def send_stats
		# Collect your stats here
		@total_users = User.count
		@users_per_city = users_per_city
		@users_per_country = users_per_country
		@amount_reviews = Review.count
		@review_average = Review.average(:rating)
		@reviews_today = Review.where(created_at: Date.today)
		@bookings_today = bookings_today
		@completed_bookings = Booking.where(status: 4)
		@confirmed_bookings = Booking.where(status: 1)
		@cancelled_bookings = Booking.where(status: -1)

		mail(to: 'nora@quouch-app.com', subject: 'User Stats Report')
	end

		private

	def users_per_city
		result = User.all.group_by(&:city)
		result.transform_values(&:count)
	end

	def users_per_country
		result = User.all.group_by(&:country)
		result.transform_values(&:count)
	end

	def bookings_today
		result = Booking.where(booking_date: Date.today).group_by(&:request) if Booking.where(booking_date: Date.today)
		result.transform_values(&:count)
	end
end
