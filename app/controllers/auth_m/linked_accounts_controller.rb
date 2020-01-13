module AuthM
  class LinkedAccountsController < ApplicationController
    include AuthM::LinkedAccountsControllerConcern
    # authorize_resource

    # def unlink
    #   super
    # end
  end
end