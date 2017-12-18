FactoryBot.define do
  factory :auth_m_person, class: 'AuthM::Person' do
    sequence(:id){|n| n }
    sequence(:first_name){|n| "first_name_dummy#{n}" }
    sequence(:last_name){|n| "last_name_dummy#{n}" }
    dni Random.rand  22000000..40000000
    association :management, factory: :auth_m_management
  end
end
