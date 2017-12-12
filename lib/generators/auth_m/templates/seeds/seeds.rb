# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AuthM::User.create(email:"root@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:root], active: true).save(validate: false)

management_1 = AuthM::Management.create(name: "Empresa 1")
management_2 = AuthM::Management.create(name: "Empresa 2")

admin_management_1 = management_1.users.create(email:"admin1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true)
admin_management_2 = management_2.users.create(email:"admin2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true)

user_management_1 = management_1.users.create(email:"user1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true)
user_management_2 = management_1.users.create(email:"user2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true)
user_management_3 = management_2.users.create(email:"user3@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true)

