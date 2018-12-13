# == Schema Information
#
# Table name: auth_m_policy_groups
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  management_id :bigint(8)
#  customized    :boolean          default(TRUE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'active_support/concern'

module AuthM::PolicyGroupConcern
  extend ActiveSupport::Concern
  
  included do

    belongs_to :management
    has_many :policies, dependent: :destroy
    has_many :users, dependent: :restrict_with_error

    accepts_nested_attributes_for :policies, allow_destroy: true

    validates :name, presence: true, length: { in: 4..250 }
    before_save :capitalize_name

    scope :allocable, -> {where(customized: false)}

  end

  def customized? 
    self.customized
  end

  def has_the_policy? resource_id
    self.policies.find_by(resource_id: resource_id)
  end

  private 

    def capitalize_name
      self.name = self.name.capitalize
    end
end