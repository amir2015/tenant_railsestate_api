class Api::V1::PropertiesController < ApplicationController
  before_action :authenticate_user_from_token!
  before_action :set_property, only: [:show, :update, :destroy]

  def search
    @q=Property.ransnack(search_params)
    @properties=@q.result(distinct: true)
    render json: @properties
  end

  def index
    @properties = Property.all
    render json: @properties


  end

  def show
    render json: @property
  end

  def create
    @property = Property.new(property_params)
    @property.company = current_user.company
    @property.agent = current_user if current_user.role=="agent"
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

  private

  def search_params
    params.require(:q).permit! if params[:q]
  end

  def set_property
    @property = Property.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Property not found" }, status: :not_found
  end

  def property_params
    params.require(:property).permit(:title, :description, :property_type, :listing_type, :price,
    :address, :city, :state, :zip_code, :country,:lat, :lng,
    :bedrooms, :bathrooms, :square_feet, :lot_size, :year_built,
    :status, :featured)
  end
  def authenticate_user!
    unless current_user
      render json: { error: "Unauthorized" }, status: :unauthorized
      return
    end
  end
end
