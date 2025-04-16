module Api
  module V1
    class RootEndpoint < Grape::API
      format :json

      helpers Api::V1::ValidationHelper

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({
          status: 404,
          message: 'Resource not found',
          error: "#{e.model} with ID #{e.id} not found"
        }, 404)
      end

      rescue_from Api::V1::ApiErrors::InsufficientFundsError do |e|
        error!({
          status: 422,
          message: 'Transaction failed',
          error: e.message
        }, 422)
      end

      mount Api::V1::Wallets::DepositEndpoint => "/wallets/:id/deposit"
      mount Api::V1::Wallets::WithdrawEndpoint => "/wallets/:id/withdraw"
      mount Api::V1::Wallets::TransferEndpoint => "/wallets/transfer"
      mount Api::V1::Wallets::InfoEndpoint => "/wallets/:id/info"
    end
  end
end
