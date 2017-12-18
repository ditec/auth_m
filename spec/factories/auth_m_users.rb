FactoryBot.define do 
  factory :auth_m_user, class: 'AuthM::User' do
    sequence(:id){|n| n }
    password "12345678"
    sequence(:email){|n| "dummy_#{n}@factory.com" }
    active true
    association :person, factory: :auth_m_person
  end
end
