class AddExpirationDateToAccounts < ActiveRecord::Migration[5.1]
  def change
  add_column :Accounts, :expirationDate, :string
  end
end
