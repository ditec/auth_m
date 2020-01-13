# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

AuthM::User.create(username: "root",
                   email:"root@a.com",
                   password:"Asd12345",
                   password_confirmation:"Asd12345",
                   roles: [:root],
                   active: true,
                   confirmed_at: DateTime.now.to_date).save(validate: false) unless AuthM::User.where(email: "root@a.com").exists?

management1 =  AuthM::Management.create!(name: "management 1")
management2 = AuthM::Management.create!(name: "management 2")

branch_1 = management1.branches.create!(name: "branch 1")
branch_2 = management1.branches.create!(name: "branch 2")
branch_3 = management2.branches.create!(name: "branch 3")
 
policy_group1 = branch_1.policy_groups.create!(name: "policies_branch_1", customized: false)
policy_group2 = branch_2.policy_groups.create!(name: "policies_branch_2", customized: false)

user_branch_1 = management1.users.create!(email:"user1@a.com", username: "user1", password:"Asd12345", password_confirmation:"Asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date, policy_groups: [policy_group1, policy_group2])
user_branch_2 = management1.users.create!(email:"user2@a.com", username: "user2", password:"Asd12345", password_confirmation:"Asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date, policy_groups: [policy_group1])
user_branch_3 = management2.users.create!(email:"user3@a.com", username: "user3", password:"Asd12345", password_confirmation:"Asd12345", roles: [:user], active: true, confirmed_at: DateTime.now.to_date)