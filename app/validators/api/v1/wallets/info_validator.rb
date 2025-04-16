module Api
  module V1
    module Wallets
      class InfoValidator < Dry::Validation::Contract
        params do
          required(:id).filled(:integer)
        end
      end
    end
  end
end 