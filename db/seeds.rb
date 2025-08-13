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

puts "\n Seed completed!"
puts "\n Summary:"
puts "Companies: #{Company.count}"
companies.each do |subdomain, company|
  ActsAsTenant.with_tenant(company) do
    puts "  #{company.name} (#{subdomain}): #{User.count} users"
  end
end

puts "\n Test Credentials:"
puts "ACME Real Estate (http://acme.lvh.me:3000):"
puts "  admin@acme.com / securepassword123 (Company Admin)"
puts "  john@acme.com / password123 (Team Lead)"
puts "  jane@acme.com / password123 (Agent)"

puts "\nSunshine Properties (http://sunshine.lvh.me:3000):"
puts "  admin@sunshine.com / securepassword123 (Company Admin)"
puts "  mike@sunshine.com / password123 (Agent)"

puts "\nDemo Real Estate (http://demo.lvh.me:3000):"
puts "  admin@demo.com / securepassword123 (Company Admin)"
