# == Schema Information
#
# Table name: companies
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  subdomain      :string           not null
#  logo_url       :string
#  settings       :jsonb
#  plan_type      :string
#  address        :string
#  phone          :string
#  license_number :string
#  website        :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
  validates :subdomain,
            presence: true,
            uniqueness: { case_sensitive: false },
            format: {
              with: /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/,
              message: "must be lowercase with letters, numbers, and hyphens"
            }

  before_validation :downcase_subdomain

  private

  def downcase_subdomain
    self.subdomain = subdomain.downcase if subdomain.present?
  end
end
