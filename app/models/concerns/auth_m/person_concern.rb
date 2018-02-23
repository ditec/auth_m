# == Schema Information
#
# Table name: auth_m_people
#
#  id            :integer          not null, primary key
#  first_name    :string(255)      default(""), not null
#  last_name     :string(255)      default(""), not null
#  dni           :string(255)
#  management_id :integer          default(0), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  city_id       :integer
#

require 'active_support/concern'

module AuthM::PersonConcern
  extend ActiveSupport::Concern
  
  included do
    belongs_to :management, optional: true
    has_one :user, dependent: :destroy

    validates :first_name, :last_name, presence: true, length: { in: 4..250 }
    validates :dni, uniqueness: true, numericality: { only_integer: true }, length: { in: 6..20 }, allow_nil: true
    before_save :capitalize_names

  end

  private 

    def capitalize_names
      self.first_name = self.first_name.capitalize
      self.last_name = self.last_name.capitalize
    end

end