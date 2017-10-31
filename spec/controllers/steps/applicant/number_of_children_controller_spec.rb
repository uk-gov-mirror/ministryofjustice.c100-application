require 'rails_helper'

RSpec.describe Steps::Applicant::NumberOfChildrenController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::NumberOfChildrenForm, C100App::ApplicantDecisionTree
end
