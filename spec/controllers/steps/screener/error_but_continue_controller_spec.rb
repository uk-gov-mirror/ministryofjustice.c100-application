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

    context 'when the courtfinder api does not throw an exception' do
      it 'sets @courtfinder_ok with the value of CourtfinderAPI.is_ok?' do
        get :show, session: { c100_application_id: existing_case.id }
        expect( assigns[:courtfinder_ok] ).to_not be_nil
      end
    end

    context 'when the courtfinder api does throw an exception' do
      before do
        allow_any_instance_of(C100App::CourtfinderAPI).to receive(:is_ok?).and_raise(error_class)
      end
      context 'of class SocketError' do
        let(:error_class){ SocketError }
        it 'sets @courtfinder_ok to false' do
          get :show, session: { c100_application_id: existing_case.id }
          expect( assigns[:courtfinder_ok] ).to eq(false)
        end
      end
      context 'of another type' do
        let(:error_class){ ArgumentError }
        it 'lets the exception bubble out' do
          expect{ get :show, session: { c100_application_id: existing_case.id } }.to raise_error
        end
      end
    end

  end
end
