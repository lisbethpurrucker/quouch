class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  acts_as_token_authentication_handler_for User, except: :home

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    # For additional fields in app/views/users/registrations/new.html.erb
    # devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :date_of_birth, :email, :password, :password_confirmation])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:photo, :first_name, :last_name, :date_of_birth, :pronouns, :address, :street, :zipcode, :summary, :offers_couch, :offers_co_work, :offers_hang_out, :question_one, :question_two, :question_three, :question_four, :address, user_characteristic_attributes: [:characteristic_ids], couch_attributes: [:capacity], couch_facility_attributes: [:facility_ids]])

    # For additional in app/views/users/registrations/edit.html.erb
    devise_parameter_sanitizer.permit(:account_update, keys: [:photo, :first_name, :last_name, :date_of_birth, :pronouns, :address, :street, :zipcode, :summary, :offers_couch, :offers_co_work, :offers_hang_out, :question_one, :question_two, :question_three, :question_four, :address, user_characteristic_attributes: [:characteristic_ids], couch_attributes: [:capacity], couch_facility_attributes: [:facility_ids]])
  end
end
