module AuthM
  class User < ApplicationRecord
    include AuthM::UserConcern
  end
end
