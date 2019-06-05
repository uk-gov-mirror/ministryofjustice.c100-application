require 'rails_helper'

RSpec.describe Steps::Miam::ChildProtectionCasesController, type: :controller do
  it_behaves_like 'a savepoint step controller'

  # Following examples will stub the screener sanity check for simplicity,
  # as the above `savepoint` examples already test the involved code.

  it_behaves_like 'an intermediate step controller', Steps::Miam::ChildProtectionCasesForm, C100App::MiamDecisionTree do
    before do
      allow(controller).to receive(:screener_sanity_check).and_return(true)
    end
  end

  # The following shared specs can really be used in any other step controller.
  # The important thing is to be tested in at least one, as any other will behave the same.
  it_behaves_like 'a step that can be drafted', Steps::Miam::ChildProtectionCasesForm do
    before do
      allow(controller).to receive(:screener_sanity_check).and_return(true)
    end
  end
end
