# == Schema Information
#
# Table name: auth_m_branches
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  management_id :bigint
#
# Indexes
#
#  index_auth_m_branches_on_management_id  (management_id)
#

require 'active_support/concern'

module AuthM::BranchConcern
  extend ActiveSupport::Concern

  included do
    belongs_to :management

    has_many :branch_resources, dependent: :destroy
    has_many :policy_groups, dependent: :destroy

    accepts_nested_attributes_for :branch_resources, allow_destroy: true

    validates :name, presence: true, length: { in: 4..250 }, uniqueness: {scope: :management_id}
    before_save :capitalize_name
  end

  def has_the_resource_id? resource_id
    self.branch_resources.where(management_resource_id: resource_id).exists?
  end

  def resource resource_id
    self.branch_resources.where(management_resource_id: resource_id).first
  end

  def resources
    self.branch_resources.includes(:management_resource).order("auth_m_management_resources.name ASC")
  end

  private 

    def capitalize_name
      self.name = self.name.capitalize
    end
  
end