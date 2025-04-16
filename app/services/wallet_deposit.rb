class WalletDeposit < TypedService
  attribute :wallet, StrictTypes::Instance(Wallet)
  attribute :amount, StrictTypes::Coercible::Decimal

  def call
    wallet.with_lock do
      wallet.balance += amount
      wallet.save!
      Transaction.create!(wallet: wallet, amount: amount, transaction_type: 'deposit')
    end
  end
end 