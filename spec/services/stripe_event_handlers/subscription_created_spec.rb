# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventHandlers::SubscriptionCreated do
  describe '.handle' do
    let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
    let(:stripe_customer_id) { "cus_#{SecureRandom.hex(8)}" }
    let(:event) do
      Stripe::Event.construct_from(
        id: 'evt_123',
        type: 'customer.subscription.created',
        data: { object: { id: stripe_subscription_id, customer: stripe_customer_id } }
      )
    end

    it 'creates a new subscription with unpaid status' do
      expect do
        described_class.new(event).handle
      end.to change(Subscription, :count).by(1)
      subscription = Subscription.last
      expect(subscription.stripe_subscription_id).to eq(stripe_subscription_id)
      expect(subscription.stripe_customer_id).to eq(stripe_customer_id)
      expect(subscription.status).to eq('unpaid')
    end
  end
end
