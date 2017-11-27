require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::EmergencyProceedingsForm do
  it_behaves_like 'a yes-no question form', attribute_name: :emergency_proceedings
end
