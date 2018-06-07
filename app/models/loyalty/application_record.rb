module Loyalty
  class ApplicationRecord < ActiveRecord::Base
    self.abstract_class = true
    establish_connection :"loyalty_#{Rails.env}"
  end
end
