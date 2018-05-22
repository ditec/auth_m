# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  management_id :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :auth_m_resource, class: 'AuthM::Resource' do
    sequence(:id){|n| n }
    name "AuthM::Person"
    association :management, factory: :auth_m_management
  end
end
