module SetCurrentTenant
  extend ActiveSupport::Concern

  included do
    before_action :set_current_tenant
  end

  private

  def set_current_tenant
    subdomain = request.subdomain
    return if subdomain.blank? || subdomain.downcase == "www"

    company = Company.find_by(subdomain: subdomain)
    if company
      ActAsTenant.current_tenant = company
    else
      render json: { error: "Company not found" }, status: :not_found
    end
  end
end
