require 'spec_helper'

RSpec.describe Steps::Respondent::NamesForm do
  it_behaves_like 'a names CRUD form', Respondent
end
