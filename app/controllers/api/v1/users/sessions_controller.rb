# frozen_string_literal: true

module Api
  module V1
    module Users
      # SessionsController: This controller is responsible for handling the user's login and logout.
      class SessionsController < Devise::SessionsController
        include RackSessionsFix
        # Skip the CSRF token verification for the API login and logout.
        skip_before_action :verify_authenticity_token

        respond_to? :json

        protected

        def require_no_authentication
          assert_is_devise_resource!
          return unless is_navigational_format?

          no_input = devise_mapping.no_input_strategies

          authenticated = if no_input.present?
                            args = no_input.dup.push scope: resource_name
                            warden.authenticate?(*args)
                          else
                            warden.authenticated?(resource_name)
                          end

          return unless authenticated && warden.user(resource_name)

          render json: {
            code: 409,
            message: "You're already signed in."
          }, status: :conflict
        end

        private

        def respond_with(current_user, _opts = {})
          if current_user.valid?
            render json: {
              code: 200,
              message: 'Logged in successfully.',
              data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
            }, status: :ok
          else
            render json: {
              code: 401,
              error: 'Invalid login credentials. Please try again.',
              data: { errors: current_user.errors.full_messages }
            }, status: :unauthorized, error_status: :unauthorized
          end
        end

        def respond_to_on_destroy
          if request.headers['Authorization'].present?
            jwt_payload = JWT.decode(request.headers['Authorization'].split.last,
                                     Rails.application.credentials.dig(:devise, :jwt_secret_key)).first
            current_user = User.find(jwt_payload['sub'])
          end

          if current_user
            render json: {
              code: 200,
              message: 'Logged out successfully.'
            }, status: :ok
          else
            render json: {
              code: 401,
              message: "Couldn't find an active session."
            }, status: :unauthorized
          end
        end
      end
    end
  end
end
