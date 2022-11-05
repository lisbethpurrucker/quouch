class CitiesController < ApplicationController
  def index
    @cities = City.all
  end

	def show
		@city = City.find(params[:id])
		@city_id = params[:id]
		@hosts = User.all.where(city_id: @city_id)
	end

	private

	def city_params
		params.require(:city).permit(:id, :name)
	end
end