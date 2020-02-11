require 'rails_helper'

RSpec.describe Steps::AttendingCourt::LanguageController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::AttendingCourt::LanguageForm, C100App::AttendingCourtDecisionTree
end
