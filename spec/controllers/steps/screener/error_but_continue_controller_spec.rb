require 'rails_helper'

RSpec.describe Steps::Screener::ErrorButContinueController, type: :controller do
  let(:courtfinder_ok){ true }

  before do
    allow_any_instance_of(C100App::CourtfinderAPI).to receive(:is_ok?).and_return(courtfinder_ok)
  end
  it_behaves_like 'a show step controller'

  describe '#show' do
    let!(:existing_case) { C100Application.create }
    let(:courtfinder_ok){ 'foo' }

    it 'checks if the courtfinder api is ok' do
      expect_any_instance_of(C100App::CourtfinderAPI).to receive(:is_ok?)
      get :show, session: { c100_application_id: existing_case.id }
    end

    it 'sets @courtfinder_ok with the value of CourtfinderAPI.is_ok?' do
      get :show, session: { c100_application_id: existing_case.id }
      expect( assigns[:courtfinder_ok] ).to_not be_nil
    end
  end
end
