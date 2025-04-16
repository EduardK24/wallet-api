module Api
  module V1
    module Wallets
      class TransferEndpoint < Grape::API
        desc 'Transfer funds between wallets'

        params do
          requires :from_id, type: Integer
          requires :to_id, type: Integer
          requires :amount, type: BigDecimal
        end

        post do
          validate_with(Api::V1::Wallets::TransferValidator)
          
          from_wallet = Wallet.find(params[:from_id])
          to_wallet = Wallet.find(params[:to_id])

          result = WalletService.transfer(from_wallet, to_wallet, params[:amount])

          status 200

          {
            status: 200,
            message: "Transfer successful",
            data: {
              transfer_amount: params[:amount],
              from_wallet_id: from_wallet.id,
              to_wallet_id: to_wallet.id,
              from_transaction: Entities::TransactionEntity.represent(result[:from_transaction]),
              to_transaction: Entities::TransactionEntity.represent(result[:to_transaction])
            }
          }
        end
      end
    end
  end
end
