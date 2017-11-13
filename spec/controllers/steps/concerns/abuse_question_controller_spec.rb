require 'rails_helper'

RSpec.describe Steps::Concerns::AbuseQuestionController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::Concerns::AbuseQuestionForm, C100App::ConcernsDecisionTree
end
