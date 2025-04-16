shared_context 'with wallet setup' do
  let(:user) { create(:user) }
  let(:wallet) { create(:wallet, user: user, balance: 1000) }
  let(:valid_headers) { { 'Accept' => 'application/json', 'Content-Type' => 'application/json' } }
end

shared_context 'with multiple wallets' do
  include_context 'with wallet setup'

  let(:first_user) { create(:user) }
  let(:first_wallet) { create(:wallet, user: first_user, balance: 1500) }
  let(:second_user) { create(:user) }
  let(:second_wallet) { create(:wallet, user: second_user, balance: 900) }
end 