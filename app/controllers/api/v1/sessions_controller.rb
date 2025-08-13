class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_for_authentication(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])

      warden.set_user(user)

      render json: {
        status: { code: 200, message: 'Logged in successfully.' },
        data: user
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: 'Invalid email or password.' }
      }, status: :unauthorized
    end
  end

  def destroy
    if current_user
      warden.logout
      render json: {
        status: { code: 200, message: 'Logged out successfully.' }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: 'User was not logged in.' }
      }, status: :unauthorized
    end
  end

  private

  def warden
    request.env['warden']
  end

  def current_user
    warden.user
  end
end
