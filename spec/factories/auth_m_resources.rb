# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  branch_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :auth_m_resource, class: 'AuthM::Resource' do
    sequence(:id){|n| n }
    name { "AuthM::User" }
    association :branch, factory: :auth_m_branch
  end
end
