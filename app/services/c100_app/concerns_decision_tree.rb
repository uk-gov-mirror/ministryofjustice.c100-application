module C100App
  class ConcernsDecisionTree < BaseDecisionTree
    def destination
      # TODO: at the moment regardless of the answer (`yes` or `no`) we move to the
      # following question. This will change once we introduce the abuse details step.
      case abuse_subject
      when AbuseSubject::APPLICANT
        applicant_questions_destination
      when AbuseSubject::CHILDREN
        children_questions_destination
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

    def applicant_questions_destination
      case abuse_kind
      when AbuseType::OTHER
        edit(:abuse_question, subject: AbuseSubject::CHILDREN, kind: AbuseType::PHYSICAL)
      else
        questions_destination(AbuseSubject::APPLICANT)
      end
    end

    def children_questions_destination
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
        edit(:abuse_question, subject: subject, kind: AbuseType::PHYSICAL)
      when AbuseType::PHYSICAL
        edit(:abuse_question, subject: subject, kind: AbuseType::EMOTIONAL)
      when AbuseType::EMOTIONAL
        edit(:abuse_question, subject: subject, kind: AbuseType::PSYCHOLOGICAL)
      when AbuseType::PSYCHOLOGICAL
        edit(:abuse_question, subject: subject, kind: AbuseType::SEXUAL)
      when AbuseType::SEXUAL
        edit(:abuse_question, subject: subject, kind: AbuseType::FINANCIAL)
      when AbuseType::FINANCIAL
        edit(:abuse_question, subject: subject, kind: AbuseType::OTHER)
      else
        raise InvalidStep, "Unknown abuse kind: #{abuse_kind}"
      end
    end
    # rubocop:enable CyclomaticComplexity
  end
end
