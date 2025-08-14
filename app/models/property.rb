class Property < ApplicationRecord
  acts_as_tenant :company
  #Associations
  belongs_to :company
  belongs_to :agent, class_name: "User", foreign_key: "agent_id", optional: true

  #Validations
  validates :listing_type, inclusion: { in: %w[buy rent sell] }
  validates :status, inclusion: { in: %w[active pending sold rented withdrawn draft] }
  validates :bedrooms, :bathrooms, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :price, :square_feet, :lot_size, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :year_built, numericality: { greater_than_or_equal_to: 1900 }, allow_nil: true

  #Scopes
  scope :active, -> { where(status: "active") }
  scope :by_agent, ->(agent_id) { where(agent_id: agent_id) }
  scope :by_listing_type, ->(listing_type) { where(listing_type: listing_type) }
  scope :by_property_type, ->(property_type) { where(property_type: property_type) }
  scope :featured, -> { where(featured: true) }

  geocoded_by :full_address
  after_validation :geocode, if:  ->(obj) { obj.address.present? && (obj.address_changed? || obj.city_changed? || obj.state_changed? || obj.zip_code_changed?) }
  
  #Methods
  def full_address
    [address, city, state, zip_code, country].compact.join(", ")
  end

  def to_s
    title.presence || "Property #{id}"
  end
end
