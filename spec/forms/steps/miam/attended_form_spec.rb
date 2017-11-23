require 'spec_helper'

RSpec.describe Steps::Miam::AttendedForm do
  it_behaves_like 'a yes-no question form', attribute_name: :miam_attended
end
