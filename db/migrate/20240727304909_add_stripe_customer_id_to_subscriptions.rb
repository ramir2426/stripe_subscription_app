# frozen_string_literal: true

class AddStripeCustomerIdToSubscriptions < ActiveRecord::Migration[7.0]
  def change
    add_column :subscriptions, :stripe_customer_id, :string
  end
end
