module CourtfinderTokenable
  extend ActiveSupport::Concern

  def courtfinder_api_credentials
    token = CourtfinderToken.first
    return {} if token.nil? || token.expired?

    { access_token: token.access_token }
  rescue ActiveSupport::MessageEncryptor::InvalidMessage
    CourtfinderToken.first&.destroy!
    {}
  end

  def update_courtfinder_token(access_token, expires_in)
    token = CourtfinderToken.first || CourtfinderToken.new
    token.access_token = access_token
    token.expires_at = Time.current + expires_in.seconds
    token.save!
  end
end