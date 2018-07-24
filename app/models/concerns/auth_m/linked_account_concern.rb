# == Schema Information
#
# Table name: auth_m_linked_accounts
#
#  id         :bigint(8)        not null, primary key
#  user_id    :bigint(8)        not null
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'active_support/concern'

module AuthM::LinkedAccountConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :user
    
    validates :uid, uniqueness: true, presence: true

  end

end