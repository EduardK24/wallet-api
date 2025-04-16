class WalletWithdraw < TypedService
  attribute :wallet, StrictTypes::Instance(Wallet)
  attribute :amount, StrictTypes::Coercible::Decimal

  def call
    wallet.with_lock do
      raise Api::V1::ApiErrors::InsufficientFundsError if wallet.balance < amount

      wallet.balance -= amount
      wallet.save!
      Transaction.create!(wallet: wallet, amount: amount, transaction_type: 'withdraw')
    end
  end
end 