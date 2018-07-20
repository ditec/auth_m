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
    belongs_to :policy_group

    USER_ACCESS = ['none','read','manage']
    
    validate :check, :on => [:create, :update]
    validates :access, inclusion: { in: ['read','manage'] }

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
    
  end

  private

    def check
      errors.add(:error, 'Invalid policy.') if !self.policy_group.management || !(self.policy_group.management.has_the_resource_id? self.resource_id)
    end

end