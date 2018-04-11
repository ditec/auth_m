# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :integer          not null, primary key
#  name       :string(255)      default(""), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'active_support/concern'

module AuthM::ManagementConcern
  extend ActiveSupport::Concern

  included do
    has_many :people, dependent: :destroy
    has_many :resources, dependent: :destroy

    validates :name, presence: true, length: { in: 4..250 }, uniqueness: true
    before_save :capitalize_name
    before_destroy :check
  end

  def has_the_resource_name? resource_name
    self.resources.any? {|h| h.name == resource_name }
  end

  def has_the_resource_id? resource_id
    self.resources.any? {|h| h.id == resource_id }
  end

  def users
    AuthM::User.includes(:person).where(auth_m_people: {management_id: self.id} )
  end

  private 

    def capitalize_name
      self.name = self.name.capitalize
    end

    def check
      throw(:abort) if self.id == 0
    end 
  
end