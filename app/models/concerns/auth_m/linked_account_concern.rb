# == Schema Information
#
# Table name: auth_m_linked_accounts
#
#  id         :bigint           not null, primary key
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_auth_m_linked_accounts_on_provider  (provider)
#  index_auth_m_linked_accounts_on_uid       (uid)
#  index_auth_m_linked_accounts_on_user_id   (user_id)
#

require 'active_support/concern'

module AuthM::LinkedAccountConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :user
    
    validates :user, presence: true
    validates :provider, presence: true, length: {in: 2..254}
    validates :uid, uniqueness: true, presence: true, length: {in: 2..254}
  end

end