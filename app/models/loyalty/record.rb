module Loyalty
  class Record < ActiveRecord::Base
    self.abstract_class = true
    establish_connection LOYALTY_DATABASE[Rails.env]
  end
end
