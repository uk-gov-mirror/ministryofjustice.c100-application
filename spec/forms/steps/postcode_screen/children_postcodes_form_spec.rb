require 'spec_helper'

RSpec.describe Steps::PostcodeScreen::ChildrenPostcodesForm do
  it_behaves_like 'a yes-no question form', attribute_name: :children_postcodes
end
