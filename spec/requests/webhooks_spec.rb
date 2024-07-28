# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Webhooks', type: :request do
  let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
  let(:stripe_customer_id) { "cus_#{SecureRandom.hex(8)}" }
  let(:body) { '{}' }
  let(:headers) { { 'HTTP_STRIPE_SIGNATURE' => 'valid_signature' } }

  before do
    allow(Stripe::Webhook).to receive(:construct_event).and_return(stripe_event)
  end

  describe 'POST /webhooks/stripe' do
    context 'when event is customer.subscription.created' do
      let(:stripe_event) do
        Stripe::Event.construct_from(
          id: 'evt_123',
          type: 'customer.subscription.created',
          data: { object: { id: stripe_subscription_id, customer: stripe_customer_id } }
        )
      end

      it 'creates a new subscription' do
        expect do
          post '/webhooks/stripe', params: body, headers: headers, as: :json
        end.to change(Subscription, :count).by(1)
        subscription = Subscription.last
        expect(subscription.stripe_subscription_id).to eq(stripe_subscription_id)
        expect(subscription.status).to eq('unpaid')
      end
    end

    context 'when event is invoice.payment_succeeded' do
      let!(:subscription) { create(:subscription, stripe_subscription_id: stripe_subscription_id) }
      let(:stripe_event) do
        Stripe::Event.construct_from(
          id: 'evt_123',
          type: 'invoice.payment_succeeded',
          data: { object: { subscription: stripe_subscription_id } }
        )
      end

      it 'updates subscription status to paid' do
        post '/webhooks/stripe', params: body, headers: headers, as: :json
        expect(subscription.reload.status).to eq('paid')
      end
    end

    context 'when event is customer.subscription.deleted' do
      let!(:subscription) { create(:subscription, stripe_subscription_id: stripe_subscription_id) }
      let(:stripe_event) do
        Stripe::Event.construct_from(
          id: 'evt_123',
          type: 'customer.subscription.deleted',
          data: { object: { id: stripe_subscription_id } }
        )
      end

      context 'when subscription status is paid' do
        before { subscription.pay! }

        it 'updates subscription status to canceled' do
          post '/webhooks/stripe', params: body, headers: headers, as: :json
          expect(subscription.reload.status).to eq('canceled')
        end
      end

      it 'does not update subscription status if it is unpaid' do
        post '/webhooks/stripe', params: body, headers: headers, as: :json
        expect(subscription.reload.status).to eq('unpaid')
      end
    end
  end
end
