class BackofficeAuditRecord < ApplicationRecord
  # Do not remove or rename any of these to ensure the audit trail
  # is maintained. Only add new actions when needed.
  #
  enum action: {
    login: 'login',
    logout: 'logout',
    forbidden: 'forbidden',
  }

  def self.log!(author:, action:, details: {})
    create(
      author: author,
      action: action,
      details: details
    )
  end
end
