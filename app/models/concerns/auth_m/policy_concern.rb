# == Schema Information
#
# Table name: auth_m_policies
#
#  id                 :bigint           not null, primary key
#  access             :string(255)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  branch_resource_id :bigint
#  policy_group_id    :bigint
#
# Indexes
#
#  index_auth_m_policies_on_branch_resource_id  (branch_resource_id)
#  index_auth_m_policies_on_policy_group_id     (policy_group_id)
#

require 'active_support/concern'

module AuthM::PolicyConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :branch_resource
    belongs_to :policy_group

    has_one :branch, through: :branch_resource
    has_one :management, through: :branch

    USER_ACCESS = ['none','read','manage']
    
    validates :branch_resource, presence: true
    validates :policy_group, presence: true
    validates :access, inclusion: { in: ['read','manage'] }    
  end

  def resource 
    self.branch_resource
  end

end