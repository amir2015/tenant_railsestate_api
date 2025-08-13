class ApplicationController < ActionController::API
  before_action :set_current_tenant
  
  private

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
      return
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
