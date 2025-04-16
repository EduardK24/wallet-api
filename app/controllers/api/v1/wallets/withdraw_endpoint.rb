module Api
  module V1
    module Wallets
      class WithdrawEndpoint < Grape::API

        desc 'Withdraw funds from a wallet',
             success: { code: 200, model: Entities::TransactionEntity }

        params do
          requires :id, type: Integer
          requires :amount, type: BigDecimal
        end

        post do
          validate_with(Api::V1::Wallets::WithdrawValidator)

          wallet = Wallet.find(params[:id])
          transaction = WalletService.withdraw(wallet, params[:amount])

          status 200

          {
            status: 200,
            message: 'Withdrawal successful',
            data: Entities::TransactionEntity.represent(transaction)
          }
        end
      end
    end
  end
end
