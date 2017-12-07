require 'rails_helper'

RSpec.describe Steps::Applicant::NamesController, type: :controller do
  it_behaves_like 'an intermediate CRUD step controller',
                  Steps::Applicant::NamesForm,
                  C100App::ApplicantDecisionTree,
                  Applicant
end
