module Api
  module V1
    module ApiErrors
      class BaseError < StandardError; end

      class InsufficientFundsError < BaseError
        def initialize(msg = 'Insufficient funds in wallet to complete this transaction')
          super
        end
      end

      class NotFoundError < BaseError
        def initialize(msg = 'Resource not found')
          super
        end
      end
    end
  end
end