class C100Application < ApplicationRecord
  include ApplicationInquiryMethods
  include ApplicationReference

  enum status: {
    screening: 0,
    in_progress: 1,
    pending_payment: 8,
    completed: 10,
  }

  enum reminder_status: {
    first_reminder_sent: 'first_reminder_sent',
    last_reminder_sent: 'last_reminder_sent',
  }

  belongs_to :user, optional: true

  has_one  :solicitor,          dependent: :destroy
  has_one  :abduction_detail,   dependent: :destroy
  has_one  :court_order,        dependent: :destroy
  has_one  :court_proceeding,   dependent: :destroy
  has_one  :court_arrangement,  dependent: :destroy
  has_one  :miam_exemption,     dependent: :destroy
  has_one  :screener_answers,   dependent: :destroy
  has_one  :email_submission,   dependent: :destroy
  has_one  :payment_intent,     dependent: :destroy

  has_many :abuse_concerns,     dependent: :destroy
  has_many :relationships,      dependent: :destroy

  has_many :people,             dependent: :destroy
  has_many :minors
  has_many :children
  has_many :applicants
  has_many :respondents
  has_many :other_children,     dependent: :destroy
  has_many :other_parties,      dependent: :destroy

  scope :with_owner,    -> { where.not(user: nil) }
  scope :not_completed, -> { where.not(status: :completed) }
  scope :not_eligible_orphans, -> { joins(:screener_answers).where('screener_answers.local_court': nil) }

  delegate :court, to: :screener_answers, prefix: true, allow_nil: true

  # Before marking the application as completed we run a final
  # validation to ensure the basic details are fulfilled.
  #
  validates_with ApplicationFulfilmentValidator, on: :completion

  def self.purge!(date)
    where('c100_applications.created_at <= :date', date: date).destroy_all
  end
end
