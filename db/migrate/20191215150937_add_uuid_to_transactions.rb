class AddUuidToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :uuid, :string
    add_index :transactions, :uuid
  end
end
