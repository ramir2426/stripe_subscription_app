# frozen_string_literal: true

class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token

  def stripe
    event = construct_event(request)
    return if event.nil?

    StripeEventHandlers::Dispatcher.call(event)
    render json: { message: 'Success' }, status: :ok
  end

  private

  def construct_event(request)
    payload = request.body.read
    sig_header = request.env['HTTP_STRIPE_SIGNATURE']

    Stripe::Webhook.construct_event(payload, sig_header, ENV['STRIPE_WEBHOOK_SECRET'])
  rescue JSON::ParserError
    render_error('Invalid payload')
  rescue Stripe::SignatureVerificationError
    render_error('Invalid signature')
  end

  def render_error(message)
    render json: { error: message }, status: :bad_request
  end
end
