class Api::V1::CompaniesController < ApplicationController
  def show
    return render json: { message: "No current tenant" }, status: :not_found unless current_tenant

    #   company = current_tenant
    #   render json: company, status: :ok
    # rescue ActiveRecord::RecordNotFound
    #   render json: { error: "Company not found" }, status: :not_found
    # rescue StandardError => e
    #   Rails.logger.error "Error fetching company: #{e.message}"
    #   render json: { error: "Internal server error" }, status: :internal_server_error
  end

  def update
  end

  def register
    # subdomain = request.subdomain
    # if subdomain.blank? || subdomain.downcase == "www"
    #   return render json: { error: "Invalid subdomain" }, status: :bad_request
    # end

    # company = Company.find_or_initialize_by(subdomain: subdomain)
    # if company.new_record?
    #   company.name = params[:name]
    #   company.email = params[:email]
    #   company.phone = params[:phone]
    #   company.address = params[:address]
    #   company.website = params[:website]
    #   company.subdomain = subdomain
    #   if company.save
    #     render json: { message: "Company registered successfully", company: company }, status: :created
    #   else
    #     render json: { error: company.errors.full_messages }, status: :unprocessable_entity
    #   end
    # else
    #   render json: { message: "Company already exists", company: company }, status: :ok
    # end
    render json: { message: "Company registration endpoint is not implemented yet" }, status: :not_implemented
  end
end
