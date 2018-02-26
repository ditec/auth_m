# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AuthM::User.create(email:"root@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:root], active: true, confirmed_at: DateTime.now.to_date).save(validate: false)

management_1 = AuthM::Management.create(name: "Empresa 1")
management_2 = AuthM::Management.create(name: "Empresa 2")

person1 = management_1.people.create(first_name:"Pedro", last_name:"Gonzales", dni:"34234234" ) 
person2 = management_1.people.create(first_name:"Laura", last_name:"Sanchez", dni:"22343213" )
person3 = management_2.people.create(first_name:"Juan", last_name:"Pereira", dni:"19332234" ) 
person4 = management_2.people.create(first_name:"Lucas", last_name:"Negro", dni:"35332543" ) 
person5 = management_2.people.create(first_name:"Maria", last_name:"Bueno", dni:"23323432" ) 

admin_management_1 = person1.create_user(email:"admin1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true, confirmed_at: DateTime.now.to_date)
admin_management_2 = person3.create_user(email:"admin2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true, confirmed_at: DateTime.now.to_date)

user_management_1 = person2.create_user(email:"user1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date)
user_management_2 = person4.create_user(email:"user2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date)
user_management_3 = person5.create_user(email:"user3@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date)

