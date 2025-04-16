class WalletTransfer < TypedService
  attribute :from_wallet, StrictTypes::Instance(Wallet)
  attribute :to_wallet, StrictTypes::Instance(Wallet)
  attribute :amount, StrictTypes::Coercible::Decimal

  def call
    from_transaction = nil
    to_transaction = nil

    ActiveRecord::Base.transaction do
      from_wallet.with_lock do
        raise Api::V1::ApiErrors::InsufficientFundsError if from_wallet.balance < amount
        from_wallet.balance -= amount
        from_wallet.save!
        from_transaction = from_wallet.transactions.create!(amount: amount, transaction_type: 'withdraw')
      end

      to_wallet.with_lock do
        to_wallet.balance += amount
        to_wallet.save!
        to_transaction = to_wallet.transactions.create!(amount: amount, transaction_type: 'deposit')
      end
    end

    { from_transaction: from_transaction, to_transaction: to_transaction }
  end
end 