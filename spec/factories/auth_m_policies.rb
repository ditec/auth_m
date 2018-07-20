# == Schema Information
#
# Table name: auth_m_policies
#
#  id              :bigint(8)        not null, primary key
#  resource_id     :bigint(8)
#  policy_group_id :bigint(8)
#  access          :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :auth_m_policy, class: 'AuthM::Policy' do
    sequence(:id){|n| n }
    association :resource, factory: :auth_m_resource
    association :policy_group, factory: :auth_m_policy_group
    access "read"
  end
end
