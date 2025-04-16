module Api
  module V1
    module Wallets
      class TransferValidator < Dry::Validation::Contract
        params do
          required(:from_id).filled(:integer)
          required(:to_id).filled(:integer)
          required(:amount).filled(:decimal, gt?: 0)
        end

        rule(:from_id, :to_id) do
          key.failure('from_id and to_id must be different') if values[:from_id] == values[:to_id]
        end
      end
    end
  end
end 