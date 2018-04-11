# == Schema Information
#
# Table name: auth_m_policies
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  user_id     :integer
#  access      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :auth_m_policy, class: 'AuthM::Policy' do
    sequence(:id){|n| n }
    association :resource, factory: :auth_m_resource
    association :user, factory: :auth_m_user
    access "read"
  end
end
