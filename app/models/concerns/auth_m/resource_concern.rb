require 'active_support/concern'

module AuthM::ResourceConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management
    has_many :policies, dependent: :destroy
  end

  class_methods do

    def list
      Rails.application.eager_load!
      array = Array.new
      ::ApplicationRecord.descendants.each do |model|
        model_name = model.to_s
        array << [model_name.singularize,model_name.singularize]
      end
      array << ["AuthM::Person","AuthM::Person"]
      return array
    end

    def exists? resource
      self.list.collect{ |a| a.first}.include? resource
    end
  end

end