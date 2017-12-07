require 'spec_helper'

RSpec.describe Steps::Applicant::NamesForm do
  it_behaves_like 'a names CRUD form', Applicant
end
