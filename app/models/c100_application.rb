class C100Application < ApplicationRecord
  belongs_to :user, optional: true, dependent: :destroy

  has_many :applicants,  dependent: :destroy
  has_many :respondents, dependent: :destroy

  has_value_object :user_type
  has_value_object :help_paying
end
