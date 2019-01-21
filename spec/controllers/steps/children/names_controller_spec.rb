require 'rails_helper'

RSpec.describe Steps::Children::NamesController, type: :controller do
  context 'for v1 of C100 application (names are not split)' do
    before do
      allow(controller).to receive(:split_names?).and_return(false)
    end

    it_behaves_like 'an names CRUD step controller',
                    Steps::Children::NamesForm,
                    C100App::ChildrenDecisionTree,
                    Child
  end

  context 'for v2+ of C100 application (names are split)' do
    before do
      allow(controller).to receive(:split_names?).and_return(true)
    end

    it_behaves_like 'an names CRUD step controller',
                    Steps::Children::NamesSplitForm,
                    C100App::ChildrenDecisionTree,
                    Child
  end
end
