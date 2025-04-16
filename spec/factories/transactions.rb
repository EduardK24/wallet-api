FactoryBot.define do
  factory :transaction do
    wallet { nil }
    amount { "9.99" }
    transaction_type { "MyString" }
  end
end
