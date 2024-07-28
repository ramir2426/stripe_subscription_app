# frozen_string_literal: true

module StripeEventHandlers
  class SubscriptionDeleted < StripeEventHandlers::Base
    def handle
      subscription = @event.data.object
      SubscriptionService::Update.new(subscription.id, 'customer.subscription.deleted').call
    end
  end
end
