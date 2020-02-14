require 'rails_helper'

RSpec.describe Steps::AttendingCourt::SpecialAssistanceController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AttendingCourt::SpecialAssistanceForm, C100App::AttendingCourtDecisionTree
end
