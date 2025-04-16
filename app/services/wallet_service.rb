class WalletService
  def self.deposit(wallet, amount)
    WalletDeposit.call(wallet: wallet, amount: amount)
  end

  def self.withdraw(wallet, amount)
    WalletWithdraw.call(wallet: wallet, amount: amount)
  end

  def self.transfer(from_wallet, to_wallet, amount)
    WalletTransfer.call(from_wallet: from_wallet, to_wallet: to_wallet, amount: amount)
  end
end