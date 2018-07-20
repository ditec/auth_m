# == Schema Information
#
# Table name: auth_m_users
#
#  id                     :bigint(8)        not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  roles_mask             :integer          default(8), not null
#  active                 :boolean          default(FALSE), not null
#  person_id              :bigint(8)
#  policy_group_id        :bigint(8)
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  invitation_token       :string(255)
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_type        :string(255)
#  invited_by_id          :bigint(8)
#  invitations_count      :integer          default(0)
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

FactoryBot.define do 
  factory :auth_m_user, class: 'AuthM::User' do
    sequence(:id){|n| n }
    sequence(:email){|n| "dummy_#{n}@factory.com" }
    password "12345678"
    roles_mask 2
    active true
    confirmed_at DateTime.now.to_date
    association :person, factory: :auth_m_person
    association :policy_group, factory: :auth_m_policy_group
  end
end
