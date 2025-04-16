require 'rails_helper'

describe 'API V1 Wallet Info Endpoint', type: :request do
  include_context 'with multiple wallets'

  describe 'GET /api/v1/wallets/:id' do
    subject(:make_request) { get "/api/v1/wallets/#{first_wallet.id}/info", headers: valid_headers }

    context 'with valid wallet id' do
      before do
        create(:transaction, wallet: first_wallet, amount: 100, transaction_type: 'deposit')
        create(:transaction, wallet: first_wallet, amount: 50, transaction_type: 'withdraw')
        make_request
      end

      it_behaves_like 'a successful API request'

      it 'returns the wallet details' do
        expect(json_response['data']).to include('current_balance', 'transactions_count', 'transactions_overview')
      end

      it 'includes transactions overview' do
        expect(json_response['data']['transactions_overview']).to be_an(Array)
        expect(json_response['data']['transactions_overview'].length).to eq(2)
        expect(json_response['data']['transactions_overview'].first).to include('amount', 'transaction_type', 'created_at')
      end
    end

    context 'with non-existent wallet id' do
      subject(:make_request) { get "/api/v1/wallets/9999/info", headers: valid_headers }
      
      before { make_request }

      it_behaves_like 'a not found API request'
    end
  end

  describe 'GET /api/v1/wallets/:id/info with transaction filtering' do
    subject(:make_request) { get "/api/v1/wallets/#{first_wallet.id}/info", headers: valid_headers }

    context 'with valid wallet id' do
      before do
        # Create multiple transactions with different types
        create(:transaction, wallet: first_wallet, amount: 100, transaction_type: 'deposit')
        create(:transaction, wallet: first_wallet, amount: 50, transaction_type: 'withdraw')
        create(:transaction, wallet: first_wallet, amount: 75, transaction_type: 'withdraw')
        make_request
      end

      it_behaves_like 'a successful API request'

      it 'returns all transactions in the overview' do
        expect(json_response['data']['transactions_overview']).to be_an(Array)
        expect(json_response['data']['transactions_overview'].length).to eq(3)
      end

      it 'includes transaction details for each transaction' do
        transaction = json_response['data']['transactions_overview'].first
        expect(transaction).to include('amount', 'transaction_type', 'created_at')
      end
    end

    context 'with filtered transaction type' do
      subject(:make_request) { get "/api/v1/wallets/#{first_wallet.id}/info?type=deposit", headers: valid_headers }

      before do
        create(:transaction, wallet: first_wallet, amount: 100, transaction_type: 'deposit')
        create(:transaction, wallet: first_wallet, amount: 50, transaction_type: 'withdraw')
        create(:transaction, wallet: first_wallet, amount: 75, transaction_type: 'deposit')
        make_request
      end

      it_behaves_like 'a successful API request'

      it 'returns only transactions of specified type' do
        expect(json_response['data']['transactions_overview']).to be_an(Array)
        transactions_of_deposit_type = json_response['data']['transactions_overview'].select { |t| t['transaction_type'] == 'deposit' }
        expect(transactions_of_deposit_type.length).to eq(2)
      end
    end

    context 'with non-existent wallet id' do
      subject(:make_request) { get "/api/v1/wallets/6856/info", headers: valid_headers }
      
      before { make_request }

      it_behaves_like 'a not found API request'
    end
  end
end 