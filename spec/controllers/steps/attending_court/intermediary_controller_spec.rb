require 'rails_helper'

RSpec.describe Steps::AttendingCourt::IntermediaryController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AttendingCourt::IntermediaryForm, C100App::AttendingCourtDecisionTree
end
