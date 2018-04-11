# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :auth_m_management, class: 'AuthM::Management' do
    sequence(:id){|n| n }
    sequence(:name){|n| "management#{n}" }
  end
end
