FactoryBot.define do
  factory :auth_m_management, class: 'AuthM::Management' do
    sequence(:id){|n| n }
    sequence(:name){|n| "management#{n}" }
  end
end
