require 'rails_helper'

describe 'API V1 Wallet Transfer Endpoint', type: :request do
  include_context 'with multiple wallets'

  describe 'POST /api/v1/wallets/transfer' do
    subject(:make_request) do 
      post "/api/v1/wallets/transfer", params: params, headers: valid_headers
    end

    context 'with valid parameters' do
      let(:params) { { from_id: first_wallet.id, to_id: second_wallet.id, amount: 200 }.to_json }
      
      before { make_request }

      it_behaves_like 'a successful API request'

      it 'decreases the source wallet balance' do
        expect(first_wallet.reload.balance).to eq(1300)
      end

      it 'increases the destination wallet balance' do
        expect(second_wallet.reload.balance).to eq(1100)
      end

      it 'creates transfer transaction records' do
        expect(Transaction.count).to eq(2)
        
        withdraw_transaction = first_wallet.transactions.last
        expect(withdraw_transaction.amount).to eq(200)
        expect(withdraw_transaction.transaction_type).to eq('withdraw')
        
        deposit_transaction = second_wallet.transactions.last
        expect(deposit_transaction.amount).to eq(200)
        expect(deposit_transaction.transaction_type).to eq('deposit')
      end

      it 'returns the transaction details' do
        expect(json_response['data']).to be_present
        expect(json_response['message']).to include('Transfer successful')
      end
    end

    context 'with negative amount' do
      let(:params) { { from_id: first_wallet.id, to_id: second_wallet.id, amount: -50 }.to_json }
      
      before { make_request }

      it_behaves_like 'a validation failure API request'

      it 'does not change either wallet balance' do
        expect(first_wallet.reload.balance).to eq(1500)
        expect(second_wallet.reload.balance).to eq(900)
      end

      it 'does not create any transactions' do
        expect(Transaction.count).to eq(0)
      end
    end

    context 'with amount exceeding source wallet balance' do
      let(:params) { { from_id: first_wallet.id, to_id: second_wallet.id, amount: 2000 }.to_json }
      
      before { make_request }

      it_behaves_like 'a service error API request'

      it 'includes an insufficient funds message' do
        expect(json_response['error']).to include('Insufficient funds')
      end

      it 'does not change either wallet balance' do
        expect(first_wallet.reload.balance).to eq(1500)
        expect(second_wallet.reload.balance).to eq(900)
      end

      it 'does not create any transactions' do
        expect(Transaction.count).to eq(0)
      end
    end

    context 'with non-existent source wallet' do
      subject(:make_request) do
        post "/api/v1/wallets/transfer",
             params: { from_id: first_wallet.id, to_id: 9000, amount: 100 }.to_json,
             headers: valid_headers
      end
      
      before { make_request }

      it_behaves_like 'a not found API request'
    end

    context 'with non-existent destination wallet' do
      let(:params) { { from_id: first_wallet.id, to_id: 6856, amount: 100 }.to_json }
      
      before { make_request }

      it_behaves_like 'a not found API request'
    end

    context 'when transferring to the same wallet' do
      let(:params) { { from_id: first_wallet.id, to_id: first_wallet.id, amount: 100 }.to_json }
      
      before { make_request }

      it_behaves_like 'a validation failure API request'

      it 'includes an error about transferring to the same wallet' do
        expect(json_response['errors']["from_id"]).to include('from_id and to_id must be different')
      end
    end

    context 'with missing parameters' do
      let(:params) { { amount: 100 }.to_json }
      
      before { make_request }

      it_behaves_like 'a validation failure API request'
    end
  end
end 