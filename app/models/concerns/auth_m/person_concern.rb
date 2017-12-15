require 'active_support/concern'

module AuthM::PersonConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management, optional: true
    has_one :user, dependent: :destroy

    validates :first_name, :last_name, presence: true
    validates :dni, uniqueness: true

  end

end