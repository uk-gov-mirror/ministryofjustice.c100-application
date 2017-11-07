class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :persisted, -> { where.not(id: nil).order(created_at: :asc) }

  def self.has_value_object(value_object, constructor: nil, class_name: nil)
    composed_of value_object,
                allow_nil:   true,
                mapping:     [[value_object.to_s, 'value']],
                constructor: constructor,
                class_name:  class_name
  end
end
