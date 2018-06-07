class CreateLoyaltyAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :loyalty_accounts do |t|
      t.integer :level, null: false, default: 1

      t.timestamps
    end
  end
end
