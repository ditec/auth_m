require 'active_support/concern'

module AuthM::ManagementConcern
  extend ActiveSupport::Concern

  included do
    has_many :users, dependent: :destroy
    has_many :resources, dependent: :destroy

    validates :name, presence: true
  end

  def has_the_resource_name? resource_name
    self.resources.any? {|h| h.name == resource_name }
  end

  def has_the_resource_id? resource_id
    self.resources.any? {|h| h.id == resource_id }
  end
  
end