require 'spec_helper'

RSpec.describe Steps::SafetyQuestions::OtherAbuseForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :other_abuse,
                  reset_when_no: [:abuse_concern_ids]
end
