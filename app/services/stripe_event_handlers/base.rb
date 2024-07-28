# frozen_string_literal: true

module StripeEventHandlers
  class Base
    def initialize(event)
      @event = event
    end

    def handle
      raise NotImplementedError, 'Each handler must implement the handle method'
    end
  end
end
