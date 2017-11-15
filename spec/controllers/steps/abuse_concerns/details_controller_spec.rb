require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::DetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::DetailsForm, C100App::AbuseConcernsDecisionTree
end
