require 'spec_helper'

RSpec.describe Steps::Children::NamesForm do
  it_behaves_like 'a names CRUD form', Child, name_attribute: :name
end
