# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

module AuthM
  class Management < ApplicationRecord
    include AuthM::ManagementConcern

    # Your code goes here...

  end
end
