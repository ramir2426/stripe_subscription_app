# frozen_string_literal: true

# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint           not null, primary key
#  status                 :string           not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  stripe_customer_id     :string
#  stripe_subscription_id :string           not null
#
require 'rails_helper'

RSpec.describe Subscription, type: :model do
  let(:subscription) { create(:subscription) }

  it 'should have an initial state of unpaid' do
    expect(subscription.status).to eq('unpaid')
  end

  it 'should transition from unpaid to paid' do
    expect(subscription.may_pay?).to be true
    subscription.pay!
    expect(subscription.status).to eq('paid')
  end

  it 'should transition from paid to canceled' do
    subscription.pay!
    expect(subscription.may_cancel?).to be true
    subscription.cancel!
    expect(subscription.status).to eq('canceled')
  end

  it 'should not allow transition from unpaid to canceled' do
    expect(subscription.may_cancel?).to be false
    expect { subscription.cancel! }.to raise_error(AASM::InvalidTransition)
  end

  it 'should raise an error on direct status assignment' do
    expect do
      subscription.update(status: 'canceled')
    end.to raise_error(RuntimeError,
                       'Direct assignment of status is not allowed. Use state machine events instead.')
  end
end
