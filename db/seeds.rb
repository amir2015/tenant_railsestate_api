# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# company = Company.find_or_create_by!(subdomain: "acme") do |c|

#   c.name = "Acme Corp"
# end

# ActsAsTenant.with_tenant(company) do
#   company.users.find_or_create_by!(email: "admin@acme.com") do |user|
#     user.password = "password123"
#     user.first_name = "John"
#     user.last_name = "Doe"
#     user.role = :company_admin
#   end
# end

puts " Starting seed process..."

companies_data = [
  {
    name: "ACME Real Estate",
    subdomain: "acme",
    address: "123 Main St, New York, NY 10001",
    phone: "+1 (555) 123-4567",
    license_number: "RE123456",
    website: "https://acme-realestate.com",
    plan_type: "premium"
  },
  {
    name: "Sunshine Properties",
    subdomain: "sunshine",
    address: "456 Oak Ave, Los Angeles, CA 90210",
    phone: "+1 (555) 987-6543",
    license_number: "RE789012",
    website: "https://sunshine-properties.com",
    plan_type: "basic"
  },
  {
    name: "Demo Real Estate",
    subdomain: "demo",
    address: "789 Pine St, Chicago, IL 60601",
    phone: "+1 (555) 246-8135",
    license_number: "RE345678",
    website: "https://demo-realestate.com",
    plan_type: "trial"
  }
]
companies = {}
companies_data.each do |company_data|
  company = Company.find_or_create_by(subdomain: company_data[:subdomain]) do |c|
    c.assign_attributes(company_data)
  end

  if company.persisted?
    puts "✓ Created/Found company: #{company.name} (#{company.subdomain})"
    companies[company.subdomain] = company
  else
    puts "✗ Failed to create company #{company_data[:name]}: #{company.errors.full_messages.join(', ')}"
  end
end
users_data = [

  {
    company_subdomain: "acme",
    email: "admin@acme.com",
    password: "securepassword123",
    first_name: "Admin",
    last_name: "User",
    role: "company_admin",
    phone: "+1 (555) 111-1111",
    license_number: "AG001"
  },
  {
    company_subdomain: "acme",
    email: "john@acme.com",
    password: "password123",
    first_name: "John",
    last_name: "Smith",
    role: "team_lead",
    phone: "+1 (555) 111-2222",
    license_number: "AG002",
    bio: "Experienced real estate professional with 10+ years in the industry."
  },
  {
    company_subdomain: "acme",
    email: "jane@acme.com",
    password: "password123",
    first_name: "Jane",
    last_name: "Johnson",
    role: "agent",
    phone: "+1 (555) 111-3333",
    license_number: "AG003"
  },


  {
    company_subdomain: "sunshine",
    email: "admin@sunshine.com",
    password: "securepassword123",
    first_name: "Sarah",
    last_name: "Wilson",
    role: "company_admin",
    phone: "+1 (555) 222-1111",
    license_number: "SU001"
  },
  {
    company_subdomain: "sunshine",
    email: "mike@sunshine.com",
    password: "password123",
    first_name: "Mike",
    last_name: "Davis",
    role: "agent",
    phone: "+1 (555) 222-2222",
    license_number: "SU002"
  },

  {
    company_subdomain: "demo",
    email: "admin@demo.com",
    password: "securepassword123",
    first_name: "Demo",
    last_name: "Admin",
    role: "company_admin",
    phone: "+1 (555) 333-1111",
    license_number: "DM001"
  }
]
users={}
users_data.each do |user_data|
  company = companies[user_data[:company_subdomain]]
  next unless company


  ActsAsTenant.with_tenant(company) do
    user = User.find_or_create_by(email: user_data[:email]) do |u|
      u.password = user_data[:password]
      u.password_confirmation = user_data[:password]
      u.first_name = user_data[:first_name]
      u.last_name = user_data[:last_name]
      u.role = user_data[:role]
      u.company = company
      u.phone = user_data[:phone] if user_data[:phone]
      u.license_number = user_data[:license_number] if user_data[:license_number]
      u.bio = user_data[:bio] if user_data[:bio]
    end

    if user.persisted?
      puts "✓ Created/Found user: #{user.full_name} (#{user.email}) at #{company.name}"
    else
      puts "✗ Failed to create user #{user_data[:email]}: #{user.errors.full_messages.join(', ')}"
    end
  end
end
property_types = ["Single Family", "Condo", "Townhouse", "Apartment", "Land"]
listing_types = ["buy", "rent", "sell"]
statuses = ["active", "pending", "sold", "rented", "withdrawn", "draft"]

# ACME Properties (New York)
ActsAsTenant.with_tenant(companies["acme"]) do
  ny_neighborhoods = ["Manhattan", "Brooklyn", "Queens", "Bronx", "Staten Island"]
  acme_agents = User.where(company: companies["acme"], role: "agent").to_a
  next if acme_agents.empty?
  15.times do |i|
    property = Property.create!(
      title: "#{["Luxury", "Modern", "Cozy", "Spacious", "Charming"].sample} #{["Home", "Apartment", "Residence", "Loft"].sample} in #{ny_neighborhoods.sample}",
      description: "#{["Beautiful", "Stunning", "Recently renovated", "Well-maintained"].sample} #{property_types.sample} with #{["great views", "modern amenities", "historic charm", "a spacious layout"].sample}. #{["Close to public transportation.", "Walking distance to shops and restaurants.", "In a quiet neighborhood.", "Perfect for families."].sample}",
      property_type: property_types.sample,
      listing_type: listing_types.sample,
      price: rand(300000..5000000),
      address: "#{rand(1..999)} #{["Main", "Broadway", "Park", "5th", "Lexington"].sample} #{["St", "Ave", "Blvd", "Dr"].sample}",
      city: "New York",
      state: "NY",
      zip_code: ["10001", "10016", "11201", "10453"].sample,
      country: "USA",
      bedrooms: rand(1..5),
      bathrooms: rand(1..4),
      square_feet: rand(800..4000),
      lot_size: rand(0.1..1.0).round(1),
      year_built: rand(1901..2020),
      status: statuses.sample,
      featured: [true, false].sample,
      agent: acme_agents.sample,


    )
    puts "✓ Created ACME property: #{property.title}"
  end
end

# Sunshine Properties (Los Angeles)
ActsAsTenant.with_tenant(companies["sunshine"]) do
  sunshine_agents = User.where(company: companies["sunshine"], role: "agent").to_a
  next if sunshine_agents.empty?
  la_neighborhoods = ["Hollywood", "Beverly Hills", "Santa Monica", "Downtown", "Venice"]

  10.times do |i|
    property = Property.create!(
      title: "#{["Sunny", "Stylish", "Contemporary", "Elegant", "Private"].sample} #{["Home", "Villa", "Condo", "Bungalow"].sample} in #{la_neighborhoods.sample}",
      description: "#{["Gorgeous", "Bright", "Recently updated", "Architecturally significant"].sample} #{property_types.sample} featuring #{["an open floor plan", "high ceilings", "a gourmet kitchen", "a private yard"].sample}. #{["Near the beach.", "Walking distance to nightlife.", "In a prestigious school district.", "With amazing city views."].sample}",
      property_type: property_types.sample,
      listing_type: listing_types.sample,
      price: rand(500000..8000000),
      address: "#{rand(1..999)} #{["Sunset", "Wilshire", "Melrose", "Hollywood", "Santa Monica"].sample} #{["Blvd", "Ave", "St", "Dr"].sample}",
      city: "Los Angeles",
      state: "CA",
      zip_code: ["90028", "90210", "90403", "90015"].sample,
      country: "USA",
      bedrooms: rand(1..6),
      bathrooms: rand(1..5),
      square_feet: rand(1000..5000),
      lot_size: rand(0.2..2.0).round(1),
      year_built: rand(1920..2020),
      status: statuses.sample,
      featured: [true, false].sample,
      agent: sunshine_agents.sample
    )
    puts "✓ Created Sunshine property: #{property.title}"
  end
end

# Demo Properties (Chicago)
ActsAsTenant.with_tenant(companies["demo"]) do
  chicago_neighborhoods = ["Loop", "Lincoln Park", "Wicker Park", "Gold Coast", "Hyde Park"]

  5.times do |i|
    property = Property.create!(
      title: "#{["Classic", "Urban", "Renovated", "Historic", "Stylish"].sample} #{["Apartment", "Townhouse", "Loft", "Penthouse"].sample} in #{chicago_neighborhoods.sample}",
      description: "#{["Wonderful", "Sophisticated", "Recently remodeled", "Full of character"].sample} #{property_types.sample} with #{["exposed brick", "hardwood floors", "panoramic windows", "a chef's kitchen"].sample}. #{["Steps from public transit.", "Close to downtown.", "In a vibrant community.", "With easy lake access."].sample}",
      property_type: property_types.sample,
      listing_type: listing_types.sample,
      price: rand(200000..3000000),
      address: "#{rand(1..999)} #{["Michigan", "State", "Clark", "Dearborn", "Rush"].sample} #{["Ave", "St", "Blvd", "Dr"].sample}",
      city: "Chicago",
      state: "IL",
      zip_code: ["60601", "60610", "60614", "60654"].sample,
      country: "USA",
      bedrooms: rand(1..4),
      bathrooms: rand(1..3),
      square_feet: rand(700..3000),
      lot_size: rand(0.1..0.5).round(1),
      year_built: rand(1910..2020),
      status: statuses.sample,
      featured: [true, false].sample,
      agent: nil
    )
    puts "✓ Created Demo property: #{property.title}"
  end
end

puts "\n Seed completed!"
puts "\n Summary:"
puts "Companies: #{Company.count}"
companies.each do |subdomain, company|
  ActsAsTenant.with_tenant(company) do
    user_count = User.count
    property_count = Property.count
    puts "  #{company.name} (#{subdomain}): #{user_count} users, #{property_count} properties"
  end
end

puts "\nTest Credentials:"
puts "ACME Real Estate (http://acme.lvh.me:3000):"
puts "  admin@acme.com / securepassword123 (Company Admin)"
puts "  john@acme.com / password123 (Team Lead)"
puts "  jane@acme.com / password123 (Agent)"
ActsAsTenant.with_tenant(companies["acme"]) do
  puts "  #{Property.count} properties"
end

puts "\nSunshine Properties (http://sunshine.lvh.me:3000):"
puts "  admin@sunshine.com / securepassword123 (Company Admin)"
puts "  mike@sunshine.com / password123 (Agent)"
ActsAsTenant.with_tenant(companies["sunshine"]) do
  puts "  #{Property.count} properties"
end

puts "\nDemo Real Estate (http://demo.lvh.me:3000):"
puts "  admin@demo.com / securepassword123 (Company Admin)"
ActsAsTenant.with_tenant(companies["demo"]) do
  puts "  #{Property.count} properties"
end
