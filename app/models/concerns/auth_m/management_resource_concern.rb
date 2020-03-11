# == Schema Information
#
# Table name: auth_m_management_resources
#
#  id            :bigint           not null, primary key
#  name          :string(255)      not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  management_id :bigint           not null
#
# Indexes
#
#  index_auth_m_management_resources_on_management_id  (management_id)
#

require 'active_support/concern'

module AuthM::ManagementResourceConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management
    has_many :branch_resources, dependent: :destroy

    attr_accessor :selected

    validates :name, presence: true, length: { in: 2..254 }
    validates :management, presence: true

    validate :is_a_valid_resource?, :on => [ :create, :update ]
  end

  class_methods do

    def list
      array = Array.new
      Dir[Rails.root.join('app/controllers/*_controller.rb')].map { |path| (path.match(/(\w+)_controller.rb/); $1)}.each do |controller|
        cancan = (controller.camelcase + 'Controller').constantize._process_action_callbacks.inspect.to_s.include?("cancan")
        array.push(controller) if cancan
      end

      # array.push("auth_m_branches")
      array.push("auth_m_policy_groups")
      array.push("auth_m_public_users") if AuthM::Engine.public_users == true
      array.push("auth_m_users")

      array.sort_by { |h| -h.first }
    end

    def resource_exists? resource
      self.list.include? resource
    end
  end

  private 

    def is_a_valid_resource?
      errors.add(:base, :invalid_resource) unless AuthM::ManagementResource.resource_exists? self.name
    end

end