class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.references :from_account, null: false
      t.references :to_account, null: false
      t.decimal :amount, :precision => 8, :scale => 2, default: 0, null: false # default
      t.string :state, default: 'created' # sqlite doesn't have enums =\

      t.timestamps
    end
  end
end
