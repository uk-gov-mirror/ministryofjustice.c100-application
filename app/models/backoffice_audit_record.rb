class BackofficeAuditRecord < ApplicationRecord
  def self.log!(author:, action:, details: {})
    create(
      author: author,
      action: action,
      details: details
    )
  end
end
