# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
company = Company.find_or_create_by!(subdomain: "acme") do |c|

  c.name = "Acme Corp"
end

ActsAsTenant.with_tenant(company) do
  company.users.find_or_create_by!(email: "admin@acme.com") do |user|
    user.password = "password123"
    user.first_name = "John"
    user.last_name = "Doe"
    user.role = :company_admin
  end
end
