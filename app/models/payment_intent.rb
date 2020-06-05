class PaymentIntent < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :c100_application
  delegate :online_payment?, to: :c100_application

  scope :not_finished, -> { where(finished_at: nil) }

  enum status: {
    ready: 'ready',
    created: 'created',
    finished: 'finished',
    offline_method: 'offline_method',
  }

  # URLs are one-time use only. Once accessed, they are invalidated.
  def destination_url
    destination_payment_url(self, nonce: init_nonce)
  end

  # Helper method as offline payments are always final
  def offline_method!
    super() && touch(:finished_at)
  end

  def revoke_nonce!
    update_column(:nonce, nil)
  end

  private

  def init_nonce
    update_column(:nonce, _nonce) && nonce
  end

  def _nonce
    SecureRandom.hex(8)
  end
end
