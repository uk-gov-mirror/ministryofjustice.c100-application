module OrderAttributes
  include Virtus.model

  def self.included(form)
    PetitionOrder.values.each { |name| form.attribute(name, Boolean) } # rubocop:disable HashEachMethods
  end
end
