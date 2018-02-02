class Relationship < ApplicationRecord
  belongs_to :c100_application

  belongs_to :child,  foreign_key: :child_id
  belongs_to :person, foreign_key: :person_id
end
