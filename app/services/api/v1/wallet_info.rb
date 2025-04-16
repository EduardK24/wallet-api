module Api
  module V1
    class WalletInfo < TypedService
      attribute :wallet_id, StrictTypes::Integer
      attribute :transaction_type, StrictTypes::String.optional.default(nil)

      def call
        wallet

        {
          current_balance: wallet.balance,
          transactions_count: filtered_transactions.count,
          transactions_overview: transactions_overview
        }
      end

      private

      def wallet
        @wallet ||= Wallet.find(wallet_id)
      end

      def filtered_transactions
        return wallet.transactions unless transaction_type
        wallet.transactions.where(transaction_type: transaction_type)
      end

      def transactions_overview
        filtered_transactions.pluck(:amount, :transaction_type, :created_at).map do |amount, transaction_type, created_at|
          {
            amount: amount,
            transaction_type: transaction_type,
            created_at: created_at
          }
        end
      end
    end
  end
end
