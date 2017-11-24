require 'rails_helper'

RSpec.describe Steps::Petition::OtherIssueController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Petition::OtherIssueForm, C100App::PetitionDecisionTree
end
