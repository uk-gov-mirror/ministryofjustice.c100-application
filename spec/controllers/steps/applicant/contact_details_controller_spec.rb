require 'rails_helper'

RSpec.describe Steps::Applicant::ContactDetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Applicant::ContactDetailsForm, C100App::ApplicantDecisionTree
end
