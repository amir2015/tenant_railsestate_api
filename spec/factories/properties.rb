FactoryBot.define do
  factory :property do
    title { "MyString" }
    description { "MyText" }
    property_type { "MyString" }
    listing_type { "MyString" }
    price { "9.99" }
    address { "MyString" }
    city { "MyString" }
    state { "MyString" }
    zip_code { "MyString" }
    country { "MyString" }
    lat { "9.99" }
    lng { "9.99" }
    bedrooms { 1 }
    bathrooms { "9.99" }
    square_feet { 1 }
    lot_size { "9.99" }
    year_built { 1 }
    company { nil }
    agent { nil }
    status { "MyString" }
    featured { false }
  end
end
