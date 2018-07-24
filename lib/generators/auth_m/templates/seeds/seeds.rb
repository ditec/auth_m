# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# AuthM::User.create(email:"root@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:root], active: true, confirmed_at: DateTime.now.to_date).save(validate: false) unless AuthM::User.where(email: "root@a.com").exists?

management_1 = AuthM::Management.create(name: "Empresa 1")
management_2 = AuthM::Management.create(name: "Empresa 2")
 
policy_group1 = management_1.policy_groups.create(name: "policies_management_1", customized: false)
policy_group2 = management_2.policy_groups.create(name: "policies_management_2", customized: false)

admin_management_1 = management_1.users.create(email:"admin1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true, confirmed_at: DateTime.now.to_date )
admin_management_2 = management_2.users.create(email:"admin2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:admin], active: true, confirmed_at: DateTime.now.to_date)

user_management_1 = management_1.users.create(email:"user1@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date, policy_group: policy_group1)
user_management_2 = management_1.users.create(email:"user2@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date, policy_group: policy_group1)
user_management_3 = management_2.users.create(email:"user3@a.com", password:"asd12345", password_confirmation:"asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date, policy_group: policy_group2)