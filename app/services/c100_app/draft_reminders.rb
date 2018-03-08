module C100App
  class DraftReminders
    attr_reader :rule_set

    def initialize(rule_set:)
      @rule_set = rule_set
    end

    def run
      rule_set.find_each do |c100_application|
        send_reminder(c100_application)
      end
    end

    private

    # Note: the reminders are sent outside of the request-response cycle, via a
    # rake task (lib/tasks/daily_tasks.rake) and thus using `deliver_later` will not
    # work unless setting up a persistent queue.
    #
    # For this service this is not an issue as the number of emails that are likely
    # to be sent is very low, and we can afford the rake task to take a bit longer to
    # complete. But if this assumption ever changes, a persistent queue will be needed.
    #
    def send_reminder(c100_application)
      NotifyMailer.draft_expire_reminder(
        c100_application, rule_set.email_template_name
      ).deliver_now

      c100_application.update(
        status: rule_set.status_transition_to
      )
    end
  end
end
