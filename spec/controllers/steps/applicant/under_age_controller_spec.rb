require 'rails_helper'

RSpec.describe Steps::Applicant::UnderAgeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Shared::UnderAgeForm, C100App::ApplicantDecisionTree
end
