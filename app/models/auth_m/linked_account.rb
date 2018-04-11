# == Schema Information
#
# Table name: auth_m_linked_accounts
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  provider   :string(255)      not null
#  uid        :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module AuthM
  class LinkedAccount < ApplicationRecord
    include AuthM::LinkedAccountConcern
    
    # puts your code here
    
  end
end
