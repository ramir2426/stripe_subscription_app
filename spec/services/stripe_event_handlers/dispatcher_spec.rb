# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventHandlers::Dispatcher do
  describe '.call' do
    let(:event) { double('event', type: event_type) }

    context 'when event type is customer.subscription.created' do
      let(:event_type) { 'customer.subscription.created' }

      it 'calls SubscriptionCreated handler' do
        handler_instance = instance_double(StripeEventHandlers::SubscriptionCreated)
        expect(StripeEventHandlers::SubscriptionCreated).to receive(:new).with(event).and_return(handler_instance)
        expect(handler_instance).to receive(:handle)
        described_class.call(event)
      end
    end

    context 'when event type is invoice.payment_succeeded' do
      let(:event_type) { 'invoice.payment_succeeded' }

      it 'calls PaymentSucceeded handler' do
        handler_instance = instance_double(StripeEventHandlers::PaymentSucceeded)
        expect(StripeEventHandlers::PaymentSucceeded).to receive(:new).with(event).and_return(handler_instance)
        expect(handler_instance).to receive(:handle)
        described_class.call(event)
      end
    end

    context 'when event type is customer.subscription.deleted' do
      let(:event_type) { 'customer.subscription.deleted' }

      it 'calls SubscriptionDeleted handler' do
        handler_instance = instance_double(StripeEventHandlers::SubscriptionDeleted)
        expect(StripeEventHandlers::SubscriptionDeleted).to receive(:new).with(event).and_return(handler_instance)
        expect(handler_instance).to receive(:handle)
        described_class.call(event)
      end
    end

    context 'when event type is unknown' do
      let(:event_type) { 'unknown.event.type' }

      it 'raises an error' do
        expect(described_class.call(event)).to be_nil
      end
    end
  end
end
