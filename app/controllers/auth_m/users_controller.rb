module AuthM
  class UsersController < ApplicationController
    include AuthM::UsersControllerConcern
  end
end