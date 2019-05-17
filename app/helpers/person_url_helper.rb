# TODO: this is a horrible, terrible workaround for the fact we were not careful
# when we designed the URLs for people of kind `OtherParty` and we pluralised them,
# against the convention, now making it very difficult to work with them.
#
# We must fix it soon but maintaining backwards-compatibility with saved applications.
# Meanwhile, this helper will let us "hide" the horror.
#
module PersonUrlHelper
  def person_url_for(record, step:)
    if record.instance_of?(OtherParty)
      # Will return:
      #   /steps/other_parties/:step/:uuid
      polymorphic_path([:steps, :other_parties, step], id: record)
    else
      # Will return:
      #   /steps/applicant/:step/:uuid
      #   /steps/respondent/:step/:uuid
      polymorphic_path([:steps, record, step])
    end
  end
end
