require 'spec_helper'

RSpec.describe Steps::Miam::CertificationForm do
  it_behaves_like 'a yes-no question form', attribute_name: :miam_certification
end
