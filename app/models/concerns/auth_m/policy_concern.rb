require 'active_support/concern'

module AuthM::PolicyConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :resource
    belongs_to :user

    USER_ACCESS = ['none','read','manage']
  end

end