module Api
  module V1
    module Entities
      class WalletInfo < Grape::Entity
        expose :transactions_count
        expose :current_balance
        expose :transactions_overview
      end
    end
  end
end
