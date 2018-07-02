# == Schema Information
#
# Table name: auth_m_resources
#
#  id            :integer          not null, primary key
#  name          :string(255)      not null
#  management_id :integer          not null
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

    def self.descendants
      ObjectSpace.each_object(Class).select { |klass| klass < self }
    end
  end

  class_methods do

    def list
      Rails.application.eager_load!
      array = Array.new
      (::ApplicationRecord.descendants << "AuthM::Person".constantize).each do |model|
        array << [model.to_s.singularize,model.to_s.singularize]
        model.descendants.each do |descendant| 
          array << [descendant.to_s.singularize,descendant.to_s.singularize]
        end 
      end
      return array
    end

    def exists? resource
      self.list.collect{ |a| a.first}.include? resource
    end
  end

  private 

    def is_a_valid_resource?
      errors.add(:resource, 'is invalid') unless AuthM::Resource.exists? self.name
    end

end