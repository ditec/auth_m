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

module AuthM
  class LinkedAccount < ApplicationRecord
    include AuthM::LinkedAccountConcern
    
    # Your code goes here...
    
  end
end
