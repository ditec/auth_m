module AuthM
  class Users::InvitationsController < Devise::InvitationsController
    
    private

    # this is called when creating invitation
    # should return an instance of resource class
    def invite_resource
      ## skip sending emails on invite
      super
    end

    # this is called when accepting invitation
    # should return an instance of resource class
    def accept_resource
      resource = resource_class.accept_invitation!(update_resource_params)
      resource.update_attribute(:active, true)
      ## Report accepting invitation to analytics
      # Analytics.report('invite.accept', resource.id)
      resource
    end
  end
end