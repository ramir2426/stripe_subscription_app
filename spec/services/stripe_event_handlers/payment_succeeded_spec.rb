# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventHandlers::PaymentSucceeded do
  describe '.handle' do
    let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
    let!(:subscription) { create(:subscription, stripe_subscription_id: stripe_subscription_id) }
    let(:event) do
      Stripe::Event.construct_from(
        id: 'evt_123',
        type: 'invoice.payment_succeeded',
        data: { object: { subscription: stripe_subscription_id } }
      )
    end

    it 'updates subscription status to paid' do
      described_class.new(event).handle
      expect(subscription.reload.status).to eq('paid')
    end
  end
end
