require 'rails_helper'

describe WalletService do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, user: user, balance: 1000) }
  let(:second_user) { create(:user) }
  let(:second_wallet) { create(:wallet, user: second_user, balance: 500) }

  describe '.deposit' do
    it 'delegates to WalletDeposit service' do
      expect(WalletDeposit).to receive(:call).with(wallet: wallet, amount: 200)
      WalletService.deposit(wallet, 200)
    end

    it 'increases the wallet balance' do
      transaction = WalletService.deposit(wallet, 200)
      
      expect(wallet.reload.balance).to eq(1200)
      expect(transaction).to be_a(Transaction)
      expect(transaction.transaction_type).to eq('deposit')
      expect(transaction.amount).to eq(200)
    end
  end

  describe '.withdraw' do
    it 'delegates to WalletWithdraw service' do
      expect(WalletWithdraw).to receive(:call).with(wallet: wallet, amount: 200)
      WalletService.withdraw(wallet, 200)
    end

    it 'decreases the wallet balance' do
      transaction = WalletService.withdraw(wallet, 200)
      
      expect(wallet.reload.balance).to eq(800)
      expect(transaction).to be_a(Transaction)
      expect(transaction.transaction_type).to eq('withdraw')
      expect(transaction.amount).to eq(200)
    end

    it 'raises an error when amount exceeds balance' do
      expect {
        WalletService.withdraw(wallet, 1200)
      }.to raise_error(/Insufficient funds/)
    end
  end

  describe '.transfer' do
    it 'delegates to WalletTransfer service' do
      expect(WalletTransfer).to receive(:call).with(from_wallet: wallet, to_wallet: second_wallet, amount: 200)
      WalletService.transfer(wallet, second_wallet, 200)
    end

    it 'transfers funds between wallets' do
      result = WalletService.transfer(wallet, second_wallet, 200)
      
      expect(wallet.reload.balance).to eq(800)
      expect(second_wallet.reload.balance).to eq(700)
      expect(result).to be_a(Hash)
      expect(result[:from_transaction]).to be_a(Transaction)
      expect(result[:to_transaction]).to be_a(Transaction)
    end

    it 'creates appropriate transaction records' do
      result = WalletService.transfer(wallet, second_wallet, 200)
      
      from_transaction = result[:from_transaction]
      to_transaction = result[:to_transaction]
      
      expect(from_transaction.transaction_type).to eq('withdraw')
      expect(from_transaction.amount).to eq(200)
      expect(from_transaction.wallet).to eq(wallet)
      
      expect(to_transaction.transaction_type).to eq('deposit')
      expect(to_transaction.amount).to eq(200)
      expect(to_transaction.wallet).to eq(second_wallet)
    end

    it 'raises an error when amount exceeds source wallet balance' do
      expect {
        WalletService.transfer(wallet, second_wallet, 1200)
      }.to raise_error(/Insufficient funds/)
    end
  end
end 