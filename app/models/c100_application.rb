class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_many :applicants, dependent: :destroy
  has_many :saved_applicants, -> { where.not(id: nil).order(created_at: :asc) }, class_name: Applicant

  has_many :respondents, dependent: :destroy
  has_many :saved_respondents, -> { where.not(id: nil).order(created_at: :asc) }, class_name: Respondent

  has_value_object :user_type
  has_value_object :help_paying
end
