# == Schema Information
#
# Table name: auth_m_managements
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'active_support/concern'

module AuthM::ManagementConcern
  extend ActiveSupport::Concern

  included do
    has_many :management_resources, inverse_of: :management, dependent: :destroy
    has_many :branches, inverse_of: :management, dependent: :destroy
    has_many :users, dependent: :destroy

    accepts_nested_attributes_for :management_resources, allow_destroy: true
    
    validates :name, presence: true, length: { maximum: 254 }
    validates :name, uniqueness: true, on: :create
    before_save :capitalize_name
  end

  def has_the_resource_name? resource_name
    self.management_resources.any? {|h| h.name == resource_name }
  end 

  def has_the_resource_id? resource_id
    self.management_resources.any? {|h| h.id == resource_id }
  end

  def resource name 
    self.management_resources.where(name: name).first if self.has_the_resource_name? name
  end 

  def resources 
    self.management_resources.order("name ASC")
  end

  private 

    def capitalize_name
      self.name = self.name.capitalize
    end
  
end