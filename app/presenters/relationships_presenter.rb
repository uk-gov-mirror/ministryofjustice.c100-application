class RelationshipsPresenter
  RELATION_SEPARATOR = ' - '.freeze
  PEOPLE_SEPARATOR = '; '.freeze

  attr_reader :c100_application

  def initialize(c100_application)
    @c100_application = c100_application
  end

  def relationship_to_children(person_or_people, show_person_name: true)
    relationships.where(minor: minors, person: person_or_people).map do |relationship|
      person_full_name = show_person_name ? relationship.person.full_name : nil
      child_full_name  = relationship.minor.full_name
      relation = i18n_relation(relationship)

      [person_full_name, relation, child_full_name].compact.join(RELATION_SEPARATOR)
    end.join(PEOPLE_SEPARATOR)
  end

  private

  def minors
    c100_application.minors
  end

  def relationships
    c100_application.relationships
  end

  def i18n_relation(relationship)
    return relationship.relation_other_value if relationship.relation.eql?(Relation::OTHER.to_s)
    I18n.translate!(relationship.relation, scope: 'dictionary.RELATIONS')
  end
end
