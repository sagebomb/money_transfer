class CreateAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :number
      t.string :holder_name
      t.decimal :balance, :precision => 8, :scale => 2, default: 0, null: false # default
      t.index :number, unique: true

      t.timestamps
    end
  end
end
