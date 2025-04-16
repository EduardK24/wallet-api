module Api
  module V1
    module Wallets
      class DepositEndpoint < Grape::API
        desc 'Deposit funds into a wallet',
             summary: "Deposit funds",
             detail: "Returns updated balance of the wallet",
             success: { code: 200, model: Entities::TransactionEntity },
             failure: [
               [ code: 400, message: 'Bad Request'],
               [ code: 404, message: 'Wallet not found']
             ]

        params do
          requires :id, type: Integer, desc: 'Wallet ID'
          requires :amount, type: BigDecimal, desc: 'Amount to deposit'
        end

        post do
          validate_with(Api::V1::Wallets::DepositValidator)
          
          wallet = Wallet.find(params[:id])
          transaction = WalletService.deposit(wallet, params[:amount])

          status 200

          {
            status: 200,
            message: 'Deposit successful',
            data: Entities::TransactionEntity.represent(transaction)
          }
        end
      end
    end
  end
end
