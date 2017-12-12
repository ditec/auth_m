module AuthM
  class Management < ApplicationRecord
    include AuthM::ManagementConcern
  end
end
