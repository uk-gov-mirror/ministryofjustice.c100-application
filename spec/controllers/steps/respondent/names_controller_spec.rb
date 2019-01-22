require 'rails_helper'

RSpec.describe Steps::Respondent::NamesController, type: :controller do
  context 'for v1 of C100 application (names are not split)' do
    before do
      allow(controller).to receive(:split_names?).and_return(false)
    end

    it_behaves_like 'a names CRUD step controller',
                    Steps::Respondent::NamesForm,
                    C100App::RespondentDecisionTree,
                    Respondent
  end

  context 'for v2+ of C100 application (names are split)' do
    before do
      allow(controller).to receive(:split_names?).and_return(true)
    end

    it_behaves_like 'a names CRUD step controller',
                    Steps::Respondent::NamesSplitForm,
                    C100App::RespondentDecisionTree,
                    Respondent
  end
end
