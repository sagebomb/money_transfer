class Transaction < ApplicationRecord
  belongs_to :from_account, class_name: 'Account'
  belongs_to :to_account, class_name: 'Account'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :uuid, presence: true

  enum state: { created: 'created', insuficient_funds: 'insuficient_funds', done: 'done' }

  paginates_per 50
end
