require 'spec_helper'

RSpec.describe Steps::OtherParties::NamesForm do
  it_behaves_like 'a names CRUD form', OtherParty
end
