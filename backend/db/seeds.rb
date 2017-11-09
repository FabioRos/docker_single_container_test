# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password') unless Rails.env.production?

# Permissions
Permission.create(name: 'users')
Permission.create(name: 'items')
Permission.create(name: 'people')

# Admin Role
Role.create(name: 'admin', permission_ids: Permission.pluck(:id))

# Create first admin
User.create!(email: 'admin@user.com', password: 'password', password_confirmation: 'password', role: Role.last)