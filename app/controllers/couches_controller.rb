
class CouchesController < ApplicationController
	def index
		@couches = []
		if params[:query].present? && params[:characteristics].present?
			find_couches_by_characteristics
			couches = @couches.flatten
			find_couches(couches)
		elsif params[:characteristics].present? && params[:query].empty?
			find_couches_by_characteristics
		elsif params[:query].present?
			find_couches_by_location
		else
			@couches = Couch.all
		end

		respond_to do |format|
      format.html { redirect_to couches_path(@couches) }
      format.json
    end
	end

	def show
    @couch = Couch.find(params[:id])
		@host = User.find(@couch.user.id)
		@couch.user = @host
		@reviews = Review.where(couch_id: params[:id])
		@review_average = @reviews.average(:rating).to_f
		@chat = Chat.find_by(user_sender_id: current_user.id, user_receiver_id: @host.id)
  end

	private

	def find_couches(couches)
		if @city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
			@couches = couches.select { |couch| couch.city == @city }
		elsif @country = Country.find_by("name ILIKE ?", "%#{params[:query]}%")
			@couches = couches.select { |couch| couch.country == @country }
		end
	end

	def find_couches_by_location
		if @city = City.find_by("name ILIKE ?", "%#{params[:query]}%")
			@users = User.where(city: @city)
		elsif @country = Country.find_by("name ILIKE ?", "%#{params[:query]}%")
			@users = User.where(country: @country)
		end

		couches = []
		@users.each do |user|
			if !user.couch.nil?
				couches << user.couch
			end
		end
		
		couches << couches.select { |couch| couch.active == true && couch.user != current_user }
		@couches = couches.flatten.uniq
	end

	def find_couches_by_characteristics
		couches = nil
		params[:characteristics].each do |characteristic|
			user_characteristics = UserCharacteristic.where(characteristic_id: characteristic.strip)
			couches_for_characteristic = user_characteristics.map do |user_characteristic|
				user = User.find(user_characteristic.user.id)
				user.couch if user.couch&.active? && user.couch.user != current_user
			end.compact.to_set
	
			couches = couches.nil? ? couches_for_characteristic : couches & couches_for_characteristic
		end
	
		@couches = couches.to_a
	end
end
