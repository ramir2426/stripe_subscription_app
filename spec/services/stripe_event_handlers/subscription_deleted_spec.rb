# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventHandlers::SubscriptionDeleted do
  describe '.handle' do
    let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
    let!(:subscription) { create(:subscription, stripe_subscription_id:) }
    let(:event) do
      Stripe::Event.construct_from(
        id: 'evt_123',
        type: 'customer.subscription.deleted',
        data: { object: { id: stripe_subscription_id } }
      )
    end

    context 'when subscription status is paid' do
      before { subscription.pay! }

      it 'updates subscription status to canceled' do
        described_class.new(event).handle
        expect(subscription.reload.status).to eq('canceled')
      end
    end

    context 'when subscription status is unpaid' do
      it 'does not update subscription status' do
        described_class.new(event).handle
        expect(subscription.reload.status).to eq('unpaid')
      end
    end
  end
end
