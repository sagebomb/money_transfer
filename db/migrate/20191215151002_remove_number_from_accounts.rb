class RemoveNumberFromAccounts < ActiveRecord::Migration[6.0]
  def change
    remove_column :accounts, :number, :string
  end
end
