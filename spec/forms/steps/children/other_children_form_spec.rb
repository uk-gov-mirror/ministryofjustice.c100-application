require 'spec_helper'

RSpec.describe Steps::Children::OtherChildrenForm do
  it_behaves_like 'a yes-no question form', attribute_name: :other_children
end
