class PaymentIntent < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :c100_application

  scope :not_finished, -> { where(finished_at: nil) }

  # Non-persisted attribute, contains the `state` raw data.
  attribute :state, :jsonb, default: {}

  enum status: {
    ready: 'ready',
    created: 'created',
    pending: 'pending',
    success: 'success',
    failed: 'failed',
    offline_type: 'offline_type',
  }

  # URLs are one-time use only. Once accessed, they are invalidated.
  def return_url
    validate_payment_url(self, nonce: init_nonce)
  end

  def revoke_nonce!
    update_column(:nonce, nil)
  end

  def finish!(with_status: :success)
    update(
      status: with_status,
      finished_at: Time.current,
    )
  end

  private

  def init_nonce
    update_column(:nonce, SecureRandom.hex(8)) && nonce
  end
end
