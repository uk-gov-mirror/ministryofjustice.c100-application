class C100Application < ApplicationRecord
  belongs_to :user, optional: true
end
