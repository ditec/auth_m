FactoryBot.define do
  factory :auth_m_policy, class: 'AuthM::Policy' do
    sequence(:id){|n| n }

    factory :auth_m_policy_person do
      association :resource, factory: :auth_m_resource_person
    end
    
  end
end
