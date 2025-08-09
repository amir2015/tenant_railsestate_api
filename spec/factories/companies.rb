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
FactoryBot.define do
  factory :company do
    name { "MyString" }
    subdomain { "MyString" }
    logo_url { "MyString" }
    settings { "" }
    plan_type { "MyString" }
    address { "MyString" }
    phone { "MyString" }
    license_number { "MyString" }
    website { "MyString" }
  end
end
