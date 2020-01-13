# == Schema Information
#
# Table name: auth_m_policy_groups
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  branch_id :bigint(8)
#  customized    :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

FactoryBot.define do
  factory :auth_m_policy_group, class: 'AuthM::PolicyGroup' do
     sequence(:id){|n| n }
     sequence(:name){|n| "name_dummy#{n}" }
     association :branch, factory: :auth_m_branch
     customized { false }
  end
end
