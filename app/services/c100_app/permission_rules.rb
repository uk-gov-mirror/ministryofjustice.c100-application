module C100App
  class PermissionRules
    attr_reader :relationship

    def initialize(relationship)
      @relationship = relationship
    end

    # As we only ask the SGO question if the orders for the child include
    # "home" (decide who they live with and when), and consent orders don't
    # have "home" in the list of orders to select, we can safely assume
    # permission is needed if the SGO value equals to 'yes'.
    #
    def permission_needed?
      special_guardianship_order?
    end

    # Permission undecided happens when there is no SGO in force, and the
    # applicant's relation to the child is "other".
    #
    # In these cases we need to go through further questions to decide
    # if permission will be needed or not.
    # Consent order applications do not require permission.
    #
    def permission_undecided?
      return false if consent_order?

      !permission_needed? && other_relationship?
    end

    private

    def child
      @_child ||= relationship.minor
    end

    def special_guardianship_order?
      child.special_guardianship_order.eql?(
        GenericYesNo::YES.to_s
      )
    end

    def other_relationship?
      relationship.relation.eql?(
        Relation::OTHER.to_s
      )
    end

    def consent_order?
      relationship.c100_application.consent_order?
    end
  end
end
