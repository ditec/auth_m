FactoryBot.define do
  factory :auth_m_resource, class: 'AuthM::Resource' do
    sequence(:id){|n| n }
    association :management, factory: :auth_m_management

    factory :auth_m_resource_person do
      name "AuthM::Person"
    end
  end
end
