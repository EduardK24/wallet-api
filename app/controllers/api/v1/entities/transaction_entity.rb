module Api
  module V1
    module Entities
      class TransactionEntity < Grape::Entity
        expose :id, documentation: { type: 'Integer', desc: 'Transaction ID' }
        expose :wallet_id, documentation: { type: 'Integer', desc: 'Associated Wallet ID' }
        expose :amount, documentation: { type: 'BigDecimal', desc: 'Transaction amount' }
        expose :transaction_type, documentation: { type: 'String', desc: 'Type of transaction (deposit, withdraw, transfer)' }
        expose :created_at, documentation: { type: 'DateTime', desc: 'Time of transaction creation' }
        expose :updated_at, documentation: { type: 'DateTime', desc: 'Time of last update' }

        expose :current_balance do |txn, _opts|
          txn.wallet.reload.balance
        end
      end
    end
  end
end
