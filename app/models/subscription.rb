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
class Subscription < ApplicationRecord
  include AASM

  validates :stripe_subscription_id, presence: true, uniqueness: true
  validates :status, :stripe_customer_id, presence: true

  enum status: { unpaid: 'unpaid', paid: 'paid', canceled: 'canceled' }

  aasm column: 'status' do
    state :unpaid, initial: true
    state :paid
    state :canceled

    event :pay do
      transitions from: %i[unpaid paid], to: :paid
    end

    event :cancel do
      transitions from: :paid, to: :canceled
    end
  end

  def status=(_value)
    raise 'Direct assignment of status is not allowed. Use state machine events instead.'
  end
end
