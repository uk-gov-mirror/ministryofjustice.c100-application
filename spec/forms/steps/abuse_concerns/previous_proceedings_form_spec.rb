require 'spec_helper'

RSpec.describe Steps::AbuseConcerns::PreviousProceedingsForm do
  it_behaves_like 'a yes-no question form',
                  attribute_name: :children_previous_proceedings
end
