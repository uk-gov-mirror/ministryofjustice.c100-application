module C100App
  class NotifyCallback
    attr_reader :payload

    PERMITTED_ATTRIBUTES ||= %i[
      id to reference status created_at completed_at sent_at
    ].freeze

    def initialize(payload)
      @payload = HashWithIndifferentAccess.new(payload).slice(*PERMITTED_ATTRIBUTES)
    end

    def process!
      return if payload[:reference].blank?

      EmailSubmissionsAudit.create!(payload)
    end
  end
end
