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
FactoryBot.define do
  factory :user do
  end
end
