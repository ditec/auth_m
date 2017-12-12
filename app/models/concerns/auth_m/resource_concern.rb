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
      i = 0
      ::ApplicationController.descendants.each do |controller|
        controller_name = controller.to_s.chomp("Controller")
        if !(controller_name.include? "::") && !(controller_name.include? "Devise")
          array << [controller_name.singularize,controller_name.singularize]
          i += 1
        end
      end
      return array
    end

    def exists? resource
      self.list.collect{ |a| a.first}.include? resource
    end
  end

end