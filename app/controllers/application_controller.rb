class ApplicationController < ActionController::API
  include Devise::Controllers::Helpers
  include ActionController::MimeResponds

  before_action :set_current_tenant
  before_action :authenticate_user_from_token!, except: [:create]

  private

  def authenticate_user_from_token!
    token = extract_token_from_request
    return if token && current_user_from_token(token)

    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def current_user
    @current_user ||= current_user_from_token(extract_token_from_request)
  end

  def extract_token_from_request
    auth_header = request.headers["Authorization"]
    auth_header&.chars&.last if auth_header&.start_with?("Bearer ")
  end

  def current_user_from_token(token)
    return unless token

    begin
      decoded_payload = JWT.decode(token, ENV.fetch("JWT_SECRET_KEY", nil), true, { algorithm: 'HS256' })
      payload = decoded_payload[0]

      return nil if JwtDenylist.exists?(jti: payload['jti'])

      User.find_by(id: payload['sub'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      nil
    end
  end

  def set_current_tenant
    tenant = find_tenant
    Rails.logger.info "Found tenant: #{tenant&.name || 'NONE'}"

    if tenant
      ActsAsTenant.current_tenant = tenant
    else
      render json: {
        error: 'Tenant not found',
        debug: {
          subdomain: request.subdomain,
          tenant_header: request.headers['X-Tenant-ID'],
          tenant_param: params[:tenant_id],
          available_tenants: Company.pluck(:id)
        }
      }, status: :bad_request
      nil
    end
  end

  def find_tenant
    return find_tenant_by_subdomain if request.subdomain.present?
    return find_tenant_by_header if request.headers['X-Tenant-ID'].present?
    return find_tenant_by_param if params[:tenant_id].present?

    nil
  end

  def find_tenant_by_subdomain
    Company.find_by(subdomain: request.subdomain)
  end

  def find_tenant_by_header
    Company.find_by(id: request.headers['X-Tenant-ID'])
  end

  def find_tenant_by_param
    Company.find_by(id: params[:tenant_id])
  end
end
