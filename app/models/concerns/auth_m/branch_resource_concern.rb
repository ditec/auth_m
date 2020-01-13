# == Schema Information
#
# Table name: auth_m_branch_resources
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  branch_id              :bigint           not null
#  management_resource_id :bigint           not null
#
# Indexes
#
#  index_auth_m_branch_resources_on_branch_id               (branch_id)
#  index_auth_m_branch_resources_on_management_resource_id  (management_resource_id)
#

require 'active_support/concern'

module AuthM::BranchResourceConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :branch
    belongs_to :management_resource

    has_one :management, through: :management_resource
    has_many :policies, inverse_of: :branch_resource, dependent: :destroy

    attr_accessor :selected

    validates :branch, presence: true
    validates :management_resource, presence: true

    validate :is_a_valid_resource?, :on => [ :create, :update ]
  end

  def name
    self.management_resource.name
  end

  private 

    def is_a_valid_resource?
      errors.add(:base, :invalid_resource) unless self.management.resources.collect(&:id).include? self.management_resource_id
    end

end