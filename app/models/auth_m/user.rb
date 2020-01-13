# == Schema Information
#
# Table name: auth_m_users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean          default(TRUE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  expired_at             :datetime
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_limit       :integer
#  invitation_sent_at     :datetime
#  invitation_token       :string(255)
#  invitations_count      :integer          default(0)
#  invited_by_type        :string(255)
#  last_activity_at       :datetime
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  roles_mask             :integer          not null
#  sign_in_count          :integer          default(0), not null
#  username               :string(255)      not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  invited_by_id          :bigint
#  management_id          :bigint
#  unique_session_id      :string(255)
#
# Indexes
#
#  index_auth_m_users_on_confirmation_token                 (confirmation_token)
#  index_auth_m_users_on_email                              (email) UNIQUE
#  index_auth_m_users_on_expired_at                         (expired_at)
#  index_auth_m_users_on_invitation_token                   (invitation_token) UNIQUE
#  index_auth_m_users_on_invitations_count                  (invitations_count)
#  index_auth_m_users_on_invited_by_id                      (invited_by_id)
#  index_auth_m_users_on_invited_by_type_and_invited_by_id  (invited_by_type,invited_by_id)
#  index_auth_m_users_on_last_activity_at                   (last_activity_at)
#  index_auth_m_users_on_management_id                      (management_id)
#  index_auth_m_users_on_reset_password_token               (reset_password_token) UNIQUE
#

module AuthM
  class User < ApplicationRecord
    include AuthM::UserConcern
    
    # Your code goes here...
    
  end
end
