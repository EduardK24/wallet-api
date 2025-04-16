module Api
  module V1
    module Wallets
      class WithdrawValidator < Dry::Validation::Contract
        params do
          required(:id).filled(:integer, gt?: 0)
          required(:amount).filled(:decimal, gt?: 0)
        end
      end
    end
  end
end 