module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      respond_to :json
      before_action :configure_devise_mapping

      private

      def configure_devise_mapping
        request.env['devise.mapping'] = Devise.mappings[:user]
      end


      def create
        user = User.find_by(email: params[:email])

        if user
          user.send_reset_password_instructions
          render json: { status: { code: 200, message: 'Password reset instructions sent.' } }, status: :ok
        else
          render json: { status: { code: 404, message: 'Email not found.' } }, status: :not_found
        end
      end


      def update
        user = User.reset_password_by_token(reset_password_params)

        if user.errors.empty?
          render json: { status: { code: 200, message: 'Password updated successfully.' } }, status: :ok
        else
          render json: { status: { code: 422, message: 'Password update failed.', errors: user.errors.full_messages } }, status: :unprocessable_entity
        end
      end

      def reset_password_params
        params.permit(:reset_password_token, :password, :password_confirmation)
      end
    end
  end
end
