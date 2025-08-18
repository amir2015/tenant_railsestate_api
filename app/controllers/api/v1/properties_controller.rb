class Api::V1::PropertiesController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_property, only: %i[show update destroy add_images]

  def index
    @properties = Property.all
    render json: @properties
  end

  def show
    render json: {
      property: @property,
      images: @property.images.map { |image| { url: url_for(image) } },
    }
  end

  def create
    @property = Property.new(property_params)
    @property.company = current_user.company
    @property.agent = current_user if current_user.role == "agent"
    if @property.save
      render json: @property, status: :created
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  def update
    if @property.update(property_params)
      render json: @property
    else
      render json: @property.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @property.destroy
    head :no_content
  end

  def search
    # @q = Property.ransack(search_params)
    # @properties = @q.result(distinct: true)
    # render json: @properties
    ActsAsTenant.current_tenant = current_user.company
    begin
      es_resonse = PropertySearchService.search(search_params, current_user.company_id)
      @properties = es_resonse.records
      render json: @properties
    rescue StandardError => e
      Rails.logger.error "Elasticsearch search failed: #{e.message}"
      @q = Property.ransack(search_params)
      @properties = @q.result(distinct: true)
      render json: @properties
    end
  end

  def add_images
    if params[:images].present?
      @property.images.attach(params[:images])
      if @property.save
        render json: { message: "Images added successfully" }, status: :ok
      else
        render json: @property.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "No images provided" }, status: :unprocessable_entity
    end
  end

  private

  def search_params
    params.fetch(:q, {}).permit(:title_cont, :city_eq, :price_gteq, :price_lteq, :property_type_eq, :bedrooms_gteq, :min_price, :max_price, :bedrooms_min, :bedrooms_max,
                                :bathrooms_min, :sqft_min, :year_built_min, :lat, :lng, :radius, :sort_by, :state_eq)
  end

  def set_property
    @property = Property.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Property not found" }, status: :not_found
  end

  def property_params
    params.require(:property).permit(:title, :description, :property_type, :listing_type, :price,
                                     :address, :city, :state, :zip_code, :country, :lat, :lng,
                                     :bedrooms, :bathrooms, :square_feet, :lot_size, :year_built, :images,
                                     :status, :featured)
  end

  def authenticate_user!
    return if current_user

    render json: { error: "Unauthorized" }, status: :unauthorized
    nil
  end
end
