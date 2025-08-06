class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
  validates :subdomain, uniqueness: { case_sensitive: false }
  validates :subdomain, format: { with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/, message: "must be lowercase and can only contain letters, numbers, and hyphens" }

  before_validation :downcase_subdomain

  private

  def downcase_subdomaine
    self.subdomain = subdomain.downcase
  end
end
