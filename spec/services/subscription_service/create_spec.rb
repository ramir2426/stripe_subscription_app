# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionService::Create do
  let(:stripe_subscription_id) { "sub_#{SecureRandom.hex(8)}" }
  let(:stripe_customer_id) { "cus_#{SecureRandom.hex(8)}" }
  let(:service) { described_class.new(stripe_subscription_id, stripe_customer_id) }

  it 'creates a subscription with unpaid status' do
    subscription = service.call
    expect(subscription).to be_persisted
    expect(subscription.stripe_subscription_id).to eq(stripe_subscription_id)
    expect(subscription.stripe_customer_id).to eq(stripe_customer_id)
    expect(subscription.status).to eq('unpaid')
  end
end
