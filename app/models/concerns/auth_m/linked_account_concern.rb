# == Schema Information
#
# Table name: auth_m_linked_accounts
#
#  id            :integer          not null, primary key
#  user          :integer          not null
#  provider      :string           not null, index: true
#  uid           :string           not null, index: true
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'active_support/concern'

module AuthM::LinkedAccountConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :user
    
    validates :uid, uniqueness: true, presence: true

  end

end