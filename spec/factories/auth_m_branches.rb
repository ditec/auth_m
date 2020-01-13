# == Schema Information
#
# Table name: auth_m_branches
#
#  id         :bigint(8)        not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :auth_m_branch, class: 'AuthM::Branch' do
    sequence(:id){|n| n }
    sequence(:name){|n| "branch#{n}" }
  end
end
