class Api::V1::SessionsController < ApplicationController
  respond_to :json


  def create
    user = User.find_for_authentication(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      token = generate_jwt_for_user(user)

      render json: {
        status: { code: 200, message: "Logged in successfully." },
        data: { user: user, token: token },
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "Invalid email or password." },
      }, status: :unauthorized
    end
  end

  def destroy
    current_token = extract_token_from_request

    if current_user && current_token
      revoke_jwt_token(current_token)
      render json: {
        status: { code: 200, message: "Logged out successfully." },
      }, status: :ok
    else
      render json: {
        status: { code: 401, message: "User was not logged in." },
      }, status: :unauthorized
    end
  end

  private

  def generate_jwt_for_user(user)
    token, _payload = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil)
    "Bearer #{token}"
  rescue StandardError => e
    Rails.logger.error "JWT Generation Error: #{e.message}"

    generate_manual_jwt(user)
  end

  def generate_manual_jwt(user)
  secret_jwt_key = ENV["JWT_SECRET_KEY"]
  payload = {
      sub: user.id,
      scp: "user",
      role: user.role,
      aud: nil,
      iat: Time.current.to_i,
      exp: 24.hours.from_now.to_i,
      jti: SecureRandom.uuid,
    }
    token = JWT.encode(payload, secret_jwt_key, "HS256")
    "Bearer #{token}"
  end

  def extract_token_from_request
    auth_header = request.headers["Authorization"]
    auth_header&.split(" ")&.last if auth_header&.start_with?("Bearer ")
  end

  def revoke_jwt_token(token)
  secret_jwt_key = ENV["JWT_SECRET_KEY"]

  begin
    decoded_token = JWT.decode(token, secret_jwt_key, true, { algorithm: "HS256" })
    jti = decoded_token[0]["jti"]

    DenylistJwt.create!(jti: jti, exp: Time.at(decoded_token[0]["exp"]))

  rescue JWT::DecodeError => e
    Rails.logger.error "JWT Decoding Error: #{e.message}"
  end
  end

  def authenticate_user_from_jwt
    secret_jwt_key = ENV["JWT_SECRET_KEY"]

    token = extract_token_from_request
    return nil unless token

    begin
      decoded_token = JWT.decode(token, secret_jwt_key, { algorithm: 'HS256' })
      user_id = decoded_token[0]['sub']
      User.find(user_id)
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      Rails.logger.error "JWT Authentication Error: #{e.message}"
      nil
    end
  end
end
