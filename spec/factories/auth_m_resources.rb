FactoryBot.define do
  factory :auth_m_resource, class: 'AuthM::Resource' do
    sequence(:id){|n| n }
    name "AuthM::Person"
    association :management, factory: :auth_m_management
  end
end
