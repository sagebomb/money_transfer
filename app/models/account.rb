class Account < ApplicationRecord
  validates :holder_name, presence: true
  validates :number, presence: true, uniqueness: true
  validates :balance, presence: true, numericality: { greater_than_or_equal_to: 0 }

  paginates_per 50

  def hold(amount)
    return false if balance < amount
    self.balance -= amount
  end

  def top_up(amount)
    self.balance += amount
  end
end
