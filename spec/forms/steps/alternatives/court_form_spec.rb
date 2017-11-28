require 'spec_helper'

RSpec.describe Steps::Alternatives::CourtForm do
  it_behaves_like 'a yes-no question form', attribute_name: :alternative_court
end
