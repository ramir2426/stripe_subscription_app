# frozen_string_literal: true

module StripeEventHandlers
  class Dispatcher
    EVENT_HANDLERS = {
      'customer.subscription.created' => StripeEventHandlers::SubscriptionCreated,
      'invoice.payment_succeeded' => StripeEventHandlers::PaymentSucceeded,
      'customer.subscription.deleted' => StripeEventHandlers::SubscriptionDeleted
    }.freeze

    def self.call(event)
      handler = EVENT_HANDLERS[event.type]

      unless handler
        Rails.logger.info "Unhandled event type: #{event.type}"
        return nil
      end

      handler.new(event).handle
    end
  end
end
