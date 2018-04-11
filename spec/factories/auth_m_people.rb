# == Schema Information
#
# Table name: auth_m_people
#
#  id            :integer          not null, primary key
#  first_name    :string(255)      default(""), not null
#  last_name     :string(255)      default(""), not null
#  dni           :string(255)
#  management_id :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :auth_m_person, class: 'AuthM::Person' do
    sequence(:id){|n| n }
    sequence(:first_name){|n| "first_name_dummy#{n}" }
    sequence(:last_name){|n| "last_name_dummy#{n}" }
    sequence(:dni){|n| "2343433#{n}" }
    association :management, factory: :auth_m_management
  end
end
