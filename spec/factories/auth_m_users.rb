FactoryBot.define do 
  factory :auth_m_user, class: 'AuthM::User' do
    sequence(:id){|n| n }
    sequence(:email){|n| "dummy_#{n}@factory.com" }
    password "12345678"
    roles [:user]
    active true
    association :person, factory: :auth_m_person
  end
end
