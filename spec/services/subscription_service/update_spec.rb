# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionService::Update do
  let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
  let!(:subscription) { create(:subscription, stripe_subscription_id:) }

  context 'invoice.payment_succeeded' do
    let(:service) { described_class.new(stripe_subscription_id, 'invoice.payment_succeeded') }

    it 'transitions from unpaid to paid' do
      service.call
      expect(subscription.reload.status).to eq('paid')
    end
  end

  context 'customer.subscription.deleted' do
    before { subscription.pay! }
    let(:service) { described_class.new(stripe_subscription_id, 'customer.subscription.deleted') }

    it 'transitions from paid to canceled' do
      service.call
      expect(subscription.reload.status).to eq('canceled')
    end
  end

  context 'when subscription unpaid' do
    let(:service) { described_class.new(stripe_subscription_id, 'customer.subscription.deleted') }

    it 'does not transition from unpaid to canceled' do
      service.call
      expect(subscription.reload.status).to eq('unpaid')
    end
  end
end
