class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company

  validates :first_name, :last_name, presence: true
  validates :role, presence: true
  validates :email, uniqueness: { scope: :company_id }
  
  enum role: { agent: 0, team_lead: 1, company_admin: 2, client: 3 }

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
