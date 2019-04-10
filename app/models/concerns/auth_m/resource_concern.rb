# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :bigint(8)        not null, primary key
#  name          :string(255)      not null
#  management_id :bigint(8)        not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'active_support/concern'

module AuthM::ResourceConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management
    has_many :policies, dependent: :destroy

    attr_accessor :selected

    validates :name, presence: true, length: { in: 2..250 }, format: { with: /\A[A-Z]/, :message => 'invalid format'}

    validate :is_a_valid_resource?, :on => [ :create, :update ]
  end

  class_methods do

    def list
      Rails.application.eager_load!
      array = Array.new
      ApplicationController.descendants.each do |controller|
        resource = controller.to_s.gsub("Controller", "")
        unless (resource.singularize.constantize rescue nil) == nil
          array << [resource, resource] unless (resource.include? "Application") || (resource.include? "Devise")
        end
      end
      return array.sort_by { |h| -h.first }
    end

    def exists? resource
      self.list # for tests :/
      return self.list.collect{ |a| a.first}.include? resource
    end
  end

  private 

    def is_a_valid_resource?
      errors.add(:resource, 'is invalid') unless AuthM::Resource.exists? self.name
    end

end