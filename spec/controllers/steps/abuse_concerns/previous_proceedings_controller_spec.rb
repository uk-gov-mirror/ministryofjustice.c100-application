require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::PreviousProceedingsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::PreviousProceedingsForm, C100App::AbuseConcernsDecisionTree
end
