# frozen_string_literal: true

module SubscriptionService
  class Update
    def initialize(stripe_subscription_id, event)
      @stripe_subscription_id = stripe_subscription_id
      @event = event
    end

    def call
      subscription = Subscription.find_by(stripe_subscription_id: @stripe_subscription_id)
      return unless subscription

      case @event
      when 'invoice.payment_succeeded'
        pay_subscription(subscription)
      when 'customer.subscription.deleted'
        cancel_subscription(subscription)
      end
    end

    private

    def pay_subscription(subscription)
      subscription.pay! if subscription.may_pay?
    end

    def cancel_subscription(subscription)
      subscription.cancel! if subscription.may_cancel?
    end
  end
end
