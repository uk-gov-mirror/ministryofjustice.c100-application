require 'rails_helper'

RSpec.describe Steps::Applicant::UserTypeController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::UserTypeForm, C100App::ApplicantDecisionTree
end
