class Transaction < ApplicationRecord
  belongs_to :wallet

  validates :amount, presence: true
  validates :transaction_type, presence: true
end
