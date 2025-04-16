module Api
  module V1
    module Wallets
      class InfoEndpoint < Grape::API
        helpers Api::V1::ValidationHelper
        
        desc 'Get transaction history for a wallet',
             summary: "Show transactions",
             detail: "Returns transactions info",
             success: { code: 200, model: Entities::WalletInfo },
             failure: [
               [ code: 400, message: "Bad request" ],
               [ code: 404, message: "Wallet not found" ]
             ]

        params do
          requires :id, type: Integer
          optional :type, type: String, desc: 'Filter transactions by type (deposit, withdraw, transfer)'
        end

        get do
          validate_with(Api::V1::Wallets::InfoValidator)

          status 200
          {
            status: 200,
            data: WalletInfo.call(wallet_id: params[:id], transaction_type: params[:type])
          }
        end
      end
    end
  end
end