class CourtfinderToken < ActiveRecord::Base
  include SimpleEncryptable

  before_create :only_one_record_allowed
  attr_encryptable :access_token, secret: ENV.fetch('COURT_API_CLIENT_SECRET', nil), salt: ENV.fetch('COURT_API_CLIENT_ID', nil)

  def expired?
    expires_at.blank? || (expires_at - 60.seconds) <= Time.zone.now
  end

  private

  def only_one_record_allowed
    if CourtfinderToken.count >= 1
      errors.add(:base, 'Only one CourtfinderToken record is allowed')
      return false
    end

    true
  end
end
