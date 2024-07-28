# frozen_string_literal: true

FactoryBot.define do
  factory :subscription do
    stripe_subscription_id { "sub_#{SecureRandom.hex(8)}" }
    stripe_customer_id { "cus_#{SecureRandom.hex(8)}" }
  end
end
