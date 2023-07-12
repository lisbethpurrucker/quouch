class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[home about search_city]

  def home
    @couches = Couch.where.not(user: current_user)
    @active_couches = @couches.includes(:reviews, user: [{ photo_attachment: :blob }, :characteristics]).page(params[:page]).per(30)
  end

  def search_cities
    query = params[:q].presence&.downcase
    cities = []
    countries = []

    if query.present?
      cities = User.search_city_or_country(query).pluck(:city).uniq.sort
      countries = User.search_city_or_country(query).pluck(:country).uniq.sort
    end

    @results = (cities + countries).select { |entry| entry.downcase.starts_with?(query) }
    render layout: false
  end
end
