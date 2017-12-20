# == Schema Information
#
# Table name: auth_m_policies
#
#  id          :integer          not null, primary key
#  resource_id :integer
#  user_id     :integer
#  access      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'active_support/concern'

module AuthM::PolicyConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :resource
    belongs_to :user

    USER_ACCESS = ['none','read','manage']

    validates :access, inclusion: { in: ['read','manage'] }
  end

end