module C100App
  class AbuseConcernsDecisionTree < BaseDecisionTree
    def destination
      case [step_name, abuse_subject]
      when [:question, AbuseSubject::APPLICANT]
        applicant_questions_destination
      when [:details, AbuseSubject::APPLICANT]
        applicant_details_destination
      when [:question, AbuseSubject::CHILDREN]
        children_questions_destination
      when [:details, AbuseSubject::CHILDREN]
        children_details_destination
      else
        raise InvalidStep, "Invalid step '#{step_params}'"
      end
    end

    private

    def abuse_subject
      AbuseSubject.new(step_params[:subject])
    end

    def abuse_kind
      AbuseType.new(step_params[:kind])
    end

    def answer
      GenericYesNo.new(step_params[:answer])
    end

    def applicant_questions_destination
      case answer
      when GenericYesNo::YES
        edit(:details, subject: abuse_subject, kind: abuse_kind)
      else
        applicant_details_destination
      end
    end

    def applicant_details_destination
      case abuse_kind
      when AbuseType::OTHER
        edit(:question, subject: AbuseSubject::CHILDREN, kind: AbuseType::PHYSICAL)
      else
        questions_destination(AbuseSubject::APPLICANT)
      end
    end

    def children_questions_destination
      case answer
      when GenericYesNo::YES
        edit(:details, subject: abuse_subject, kind: abuse_kind)
      else
        children_details_destination
      end
    end

    def children_details_destination
      case abuse_kind
      when AbuseType::OTHER # TODO: This is a placeholder. change when we have the `orders` step
        show('/steps/children/instructions')
      else
        questions_destination(AbuseSubject::CHILDREN)
      end
    end

    # Note: this is a lot of branching but makes for a more readable code, and is easier to
    # change the ordering. It could be refactored once we have the abuse details step.
    #
    # rubocop:disable CyclomaticComplexity
    def questions_destination(subject)
      case abuse_kind
      when AbuseType::SUBSTANCES
        edit(:question, subject: subject, kind: AbuseType::PHYSICAL)
      when AbuseType::PHYSICAL
        edit(:question, subject: subject, kind: AbuseType::EMOTIONAL)
      when AbuseType::EMOTIONAL
        edit(:question, subject: subject, kind: AbuseType::PSYCHOLOGICAL)
      when AbuseType::PSYCHOLOGICAL
        edit(:question, subject: subject, kind: AbuseType::SEXUAL)
      when AbuseType::SEXUAL
        edit(:question, subject: subject, kind: AbuseType::FINANCIAL)
      when AbuseType::FINANCIAL
        edit(:question, subject: subject, kind: AbuseType::OTHER)
      else
        raise InvalidStep, "Unknown abuse kind: #{abuse_kind}"
      end
    end
    # rubocop:enable CyclomaticComplexity
  end
end
