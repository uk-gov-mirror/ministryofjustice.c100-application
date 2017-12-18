class Person < ApplicationRecord
  belongs_to :c100_application
  has_many :relationships, dependent: :destroy
end
