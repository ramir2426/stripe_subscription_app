# frozen_string_literal: true

module StripeEventHandlers
  class SubscriptionCreated < StripeEventHandlers::Base
    def handle
      subscription = @event.data.object
      SubscriptionService::Create.new(subscription.id, subscription.customer).call
    end
  end
end
