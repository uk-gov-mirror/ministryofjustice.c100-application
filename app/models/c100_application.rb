class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_one  :abduction_detail, dependent: :destroy
  has_one  :asking_order,     dependent: :destroy
  has_one  :court_order,      dependent: :destroy
  has_one  :court_proceeding, dependent: :destroy
  has_one  :exemption,        dependent: :destroy
  has_one  :miam_exemption,   dependent: :destroy
  has_one  :screener_answers, dependent: :destroy

  has_many :abuse_concerns,   dependent: :destroy
  has_many :relationships,    dependent: :destroy

  # Remember, we are using UUIDs as the record IDs, we can't rely on ID sequential ordering
  has_many :people,      -> { order(created_at: :asc) }
  has_many :minors,      -> { order(created_at: :asc) }
  has_many :children,    -> { order(created_at: :asc) }, dependent: :destroy
  has_many :applicants,  -> { order(created_at: :asc) }, dependent: :destroy
  has_many :respondents, -> { order(created_at: :asc) }, dependent: :destroy

  has_many :other_children, -> { order(created_at: :asc) }, dependent: :destroy
  has_many :other_parties,  -> { order(created_at: :asc) }, dependent: :destroy

  has_value_object :user_type
  has_value_object :help_paying
  has_value_object :concerns_contact_type

  def confidentiality_enabled?
    address_confidentiality.eql?(GenericYesNo::YES.to_s)
  end
end
