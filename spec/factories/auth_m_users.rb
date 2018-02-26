FactoryBot.define do 
  factory :auth_m_user, class: 'AuthM::User' do
    sequence(:id){|n| n }
    sequence(:email){|n| "dummy_#{n}@factory.com" }
    password "12345678"
    roles [:user]
    active true
    confirmed_at DateTime.now.to_date
    association :person, factory: :auth_m_person
  end
end
