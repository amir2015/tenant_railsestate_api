# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  role                   :integer          default("agent"), not null
#  first_name             :string
#  last_name              :string
#  phone                  :string
#  license_number         :string
#  specialties            :text
#  bio                    :text
#  avatar_url             :string
#  timezone               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: Devise::JWT::RevocationStrategies::Denylist

  validates :first_name, :last_name, presence: true
  validates :role, presence: true
  validates :email, uniqueness: { scope: :company_id }
  enum :role, { :agent => 0, :team_lead => 1, :company_admin => 2, :client => 3 }
  belongs_to :company, optional: false
  acts_as_tenant(:company, optional: true)

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def jwt_payload
    super.merge(
      role: role,
    )
  end
end
