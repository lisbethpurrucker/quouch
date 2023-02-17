# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def update
    @country = params[:user][:country_id]
    @city = params[:user][:city_id]
    @user.update(city: set_city(@country, @city), country: set_country(@country))
    super
    @couch = @user.couch
    @couchfacilities = @couch.couch_facilities if @couch
    if @couch.nil? && @couchfacilities.nil?
      create_couch
      create_couch_facilities
    elsif @couch.present? && @couchfacilities.nil?
      update_couch
      create_couch_facilities
    else
      update_couch
      update_couch_facilities
    end

    @usercharacteristics = @user.user_characteristics
    if @usercharacteristics.nil?
      create_user_characteristics
    else
      update_user_characteristics
    end
  end

  protected

  def couch_params
    params.require(:couch).permit(:capacity)
  end

  def couch_facility_params
    params.require(:couch_facility).permit(facility_ids: [])
  end

  def user_characteristic_params
    params.require(:couch_facility).permit(characteristic_ids: [])
  end

  def create_couch
    @couch = Couch.new(couch_params)
    @couch.user = @user
    @couch.save
  end

  def update_couch
    @couch.update(couch_params)
  end

  def create_couch_facilities
    @couchfacilities = []
    delete_empty_string(couch_facility_params[:facility_ids])
    couch_facility_params[:facility_ids].each do |id|
      couchfacility = CouchFacility.create(couch_id: @couch, facility_id: id)
      @couchfacilities << couchfacility
    end
  end

  def update_couch_facilities
    create_new_facilities
    delete_old_facilities
  end

  def create_new_facilities
    new_facilities = couch_facility_params[:facility_ids].reject { |facility| @couchfacilities.include?("#{facility}") }
    delete_empty_string(new_facilities)
    new_facilities.each do |id|
      couchfacility = CouchFacility.create(couch_id: @couch, facility_id: id)
      @couchfacilities << couchfacility
    end
  end

  def delete_old_facilities
    old_facilities = @couchfacilities.reject { |facility| couch_facility_params[:facility_ids].include?("#{facility[:facility_id]}") }
    delete_empty_string(old_facilities)
    old_facilities.each { |facility| @couchfacilities.destroy(facility.id) }
  end

  def create_user_characteristics
    @usercharacteristics = []
    delete_empty_string(params[:user_characteristic][:characteristic_ids])
    params[:user_characteristic][:characteristic_ids].each do |id|
      usercharacteristic = UserCharacteristics.create(user_id: @user, characteristic_id: id)
      @usercharacteristics << usercharacteristic
    end
  end

  def update_user_characteristics
    create_new_characteristics
    delete_old_characteristics
  end

  def create_new_characteristics
    new_characteristics = params[:user_characteristic][:characteristic_ids].reject { |characteristic| @usercharacteristics.include?("#{characteristic}") }
    delete_empty_string(new_characteristics)
    new_characteristics.each do |id|
      usercharacteristic = UserCharacteristic.create(user_id: @user, characteristic_id: id)
      @usercharacteristics << usercharacteristic
    end
  end

  def delete_old_characteristics
    old_characteristics = @usercharacteristics.reject { |characteristic| params[:user_characteristic][:characteristic_ids].include?("#{characteristic[:characteristic_id]}") }
    delete_empty_string(old_characteristics)
    old_characteristics.each { |characteristic| @usercharacteristics.destroy(characteristic.id) }
  end

  def delete_empty_string(array)
    array.delete("")
  end

  def create_city(city, country)
    existing_city = City.find_by(name: city.capitalize)
    if existing_city.nil?
      City.create(name: city, country: country)
    else
      existing_city
    end
  end

  def set_city(country, city)
    existing_country = Country.find_by(name: country.capitalize)
    if existing_country.nil?
      new_country = Country.create(name: country)
      create_city(city, new_country)
    else
      create_city(city, existing_country)
    end
  end

  def set_country(country)
    existing_country = Country.find_by(name: country.capitalize)
    if existing_country.nil?
      new_country = Country.create(name: country)
    else
      existing_country
    end
  end
end
