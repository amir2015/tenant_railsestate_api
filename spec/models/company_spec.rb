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
require 'rails_helper'

RSpec.describe Company, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
