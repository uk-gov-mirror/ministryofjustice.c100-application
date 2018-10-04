class C100Application < ApplicationRecord
  include ApplicationReference

  enum status: {
    screening: 0,
    in_progress: 1,
    first_reminder_sent: 5,
    last_reminder_sent: 6,
    completed: 10,
  }

  belongs_to :user, optional: true

  has_one  :solicitor,        dependent: :destroy
  has_one  :abduction_detail, dependent: :destroy
  has_one  :court_order,      dependent: :destroy
  has_one  :court_proceeding, dependent: :destroy
  has_one  :miam_exemption,   dependent: :destroy
  has_one  :screener_answers, dependent: :destroy
  has_one  :email_submission, dependent: :destroy

  has_many :abuse_concerns,   dependent: :destroy
  has_many :relationships,    dependent: :destroy

  has_many :people,           dependent: :destroy
  has_many :minors
  has_many :children
  has_many :applicants
  has_many :respondents
  has_many :other_children,   dependent: :destroy
  has_many :other_parties,    dependent: :destroy

  scope :with_owner,    -> { where.not(user: nil) }
  scope :not_completed, -> { where.not(status: :completed) }
  scope :not_eligible_orphans, -> { joins(:screener_answers).where('screener_answers.local_court': nil) }

  delegate :court, to: :screener_answers, prefix: true, allow_nil: true

  def self.purge!(date)
    where('c100_applications.created_at <= :date', date: date).destroy_all
  end

  def online_submission?
    submission_type.eql?(SubmissionType::ONLINE.to_s)
  end

  def confidentiality_enabled?
    address_confidentiality.eql?(GenericYesNo::YES.to_s)
  end

  def has_safety_concerns?
    [
      domestic_abuse,
      risk_of_abduction,
      children_abuse,
      substance_abuse,
      other_abuse
    ].any? { |concern| concern.eql?(GenericYesNo::YES.to_s) }
  end
end
