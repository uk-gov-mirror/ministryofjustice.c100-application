class Relationship < ApplicationRecord
  belongs_to :c100_application

  belongs_to :minor
  belongs_to :person
end
