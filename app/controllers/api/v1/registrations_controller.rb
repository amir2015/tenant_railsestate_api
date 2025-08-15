module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json
      before_action :configure_devise_mapping

      private

      def configure_devise_mapping
        request.env['devise.mapping'] = Devise.mappings[:user]
      end

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            status: { code: 200, message: 'Registered successfully.' },
            data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
          }, status: :ok
        else
          render json: {
            status: { code: 422, message: 'Registration failed.', errors: resource.errors.full_messages }
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
