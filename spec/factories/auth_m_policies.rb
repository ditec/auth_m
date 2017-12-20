FactoryBot.define do
  factory :auth_m_policy, class: 'AuthM::Policy' do
    sequence(:id){|n| n }
    association :resource, factory: :auth_m_resource
    association :user, factory: :auth_m_user
    access "read"
  end
end
