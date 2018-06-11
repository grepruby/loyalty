module Loyalty
  class Account < Record
    validates :level, presence: true,
                      inclusion: { in: [1, 2, 3],
                                   message: '%{value} is not a valid level' }
    has_one :user, foreign_key: :loyalty_account_id
  end
end
