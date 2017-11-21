require 'rails_helper'

RSpec.describe Steps::AbuseConcerns::EmergencyProceedingsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AbuseConcerns::EmergencyProceedingsForm, C100App::AbuseConcernsDecisionTree
end
