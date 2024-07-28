# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StripeEventHandlers::Base do
  let(:event) { double('event') }

  describe '#initialize' do
    it 'initializes with an event' do
      handler = described_class.new(event)
      expect(handler.instance_variable_get(:@event)).to eq(event)
    end
  end

  describe '#handle' do
    it 'raises NotImplementedError when not overridden' do
      handler = described_class.new(event)
      expect { handler.handle }.to raise_error(NotImplementedError, 'Each handler must implement the handle method')
    end
  end
end
