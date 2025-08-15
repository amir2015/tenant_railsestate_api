class Api::V1::SessionsController < ApplicationController
  respond_to :json

  def create
    user = User.find_for_authentication(email: params[:user][:email])

    if user&.valid_password?(params[:user][:password])
      token = generate_jwt_for_user(user)
      render json: {
        status: { code: 200, message: "Logged in successfully." },
        data: { user: user, token: token }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Invalid email or password." }
      }, status: :unauthorized
    end
  end

  def destroy
    token = extract_token_from_request
    if token
      revoke_token(token)
      render json: {
        status: { code: 200, message: "Logged out successfully." }
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "User was not logged in." }
      }, status: :unauthorized
    end
  end

  private

  def generate_jwt_for_user(user)
    payload = {
      sub: user.id,
      scp: "user",
      role: user.role,
      iat: Time.current.to_i,
      exp: 24.hours.from_now.to_i,
      jti: SecureRandom.uuid
    }
    JWT.encode(payload, ENV.fetch("JWT_SECRET_KEY", nil), "HS256")
  end
end
