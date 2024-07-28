# frozen_string_literal: true

module SubscriptionService
  class Create
    def initialize(stripe_subscription_id, stripe_customer_id)
      @stripe_subscription_id = stripe_subscription_id
      @stripe_customer_id = stripe_customer_id
    end

    def call
      Subscription.create!(stripe_subscription_id: @stripe_subscription_id, stripe_customer_id: @stripe_customer_id)
    end
  end
end
