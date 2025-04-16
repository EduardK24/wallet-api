require 'rails_helper'

describe 'API V1 Wallet Deposit Endpoint', type: :request do
  include_context 'with wallet setup'

  describe 'POST /api/v1/wallets/:id/deposit' do

    subject(:make_request) { post "/api/v1/wallets/#{wallet.id}/deposit", params: params, headers: valid_headers }

    describe 'with valid parameters' do
      let(:params) { { amount: 100 }.to_json }
      
      before { make_request }

      it_behaves_like 'a successful API request'

      it 'increases the wallet balance' do
        expect(wallet.reload.balance).to eq(1100)
      end

      it 'creates a new transaction record' do
        expect(Transaction.count).to eq(1)
        transaction = Transaction.last
        expect(transaction.wallet_id).to eq(wallet.id)
        expect(transaction.amount).to eq(100)
        expect(transaction.transaction_type).to eq('deposit')
      end

      it 'returns the transaction details' do
        expect(json_response['data']).to include('id', 'amount', 'transaction_type')
        expect(json_response['data']['amount']).to eq('100.0')
        expect(json_response['data']['transaction_type']).to eq('deposit')
      end
    end

    context 'with negative amount' do
      let(:params) { { amount: -50 }.to_json }
      
      before { make_request }

      it_behaves_like 'a validation failure API request'

      it 'does not change the wallet balance' do
        expect(wallet.reload.balance).to eq(1000)
      end

      it 'does not create a transaction' do
        expect(Transaction.count).to eq(0)
      end
    end

    context 'with non-existent wallet' do
      subject(:make_request) { post "/api/v1/wallets/9999/deposit", params: { amount: 100 }.to_json, headers: valid_headers }
      
      before { make_request }

      it_behaves_like 'a not found API request'
    end

    context 'with missing amount parameter' do
      let(:params) { {}.to_json }
      
      before { make_request }

      it_behaves_like 'a validation failure API request'
    end
  end
end 