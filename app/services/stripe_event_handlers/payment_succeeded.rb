# frozen_string_literal: true

module StripeEventHandlers
  class PaymentSucceeded < StripeEventHandlers::Base
    def handle
      invoice = @event.data.object
      SubscriptionService::Update.new(invoice.subscription, 'invoice.payment_succeeded').call
    end
  end
end
