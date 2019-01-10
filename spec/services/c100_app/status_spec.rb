require 'rails_helper'

RSpec.describe C100App::Status do
  let(:status) do
    {
      service_status: service_status,
      version: version,
      dependencies: {
        database_status: database_status,
        courtfinder_status: courtfinder_status,
      }
    }
  end

  let(:check) { described_class.new }

  # Default is everything is fine
  let(:version) { 'ABC123' }
  let(:service_status) { 'ok' }
  let(:database_status) { 'ok' }
  let(:courtfinder_status) { 'ok' }
  let(:courtfinder_api_is_ok) { true }

  before do
    allow(ActiveRecord::Base).to receive(:connection).and_return(double)
    allow(ENV).to receive(:[]).with('APP_GIT_COMMIT').and_return(version)
    allow_any_instance_of(C100App::CourtfinderAPI).to receive(:is_ok?).and_return(courtfinder_api_is_ok)
  end

  describe 'version' do
    context 'there is a version ENV variable' do
      it 'returns the version' do
        expect(check.result).to include(version: 'ABC123')
      end
    end

    context 'there is no version ENV variable' do
      let(:version) { nil }

      it 'returns a placeholder string' do
        expect(check.result).to include(version: 'unknown')
      end
    end
  end

  describe '#service_status' do
    before do
      allow(subject).to receive(:database_status).and_return(database_status)
      allow(subject).to receive(:courtfinder_status).and_return(courtfinder_status)
    end
    context 'when database_status is "ok"' do
      let(:database_status) { 'ok' }

      context 'when courtfinder_status is "ok"' do
        let(:courtfinder_status) { 'ok' }

        it 'returns ok' do
          expect(subject.send(:service_status)).to eq('ok')
        end
      end

      context 'when courtfinder_status is not "ok"' do
        let(:courtfinder_status) { 'foo' }

        it 'returns failed' do
          expect(subject.send(:service_status)).to eq('failed')
        end
      end
    end
    context 'when courtfinder_status is "ok"' do
      let(:courtfinder_status) { 'ok' }

      context 'when database_status is not "ok"' do
        let(:database_status) { 'foo' }

        it 'returns failed' do
          expect(subject.send(:service_status)).to eq('failed')
        end
      end
    end
  end

  describe '#success?' do
    context 'for a success result' do
      it 'returns true' do
        expect(check.success?).to eq(true)
      end
    end

    context 'for a failed result' do
      let(:courtfinder_api_is_ok) { false }

      it 'returns false' do
        expect(check.success?).to eq(false)
      end
    end
  end

  describe '#result' do
    context 'database available' do
      let(:courtfinder_api_is_ok){ true }
      before do
        expect(ActiveRecord::Base).to receive(:connection).and_call_original
      end

      specify { expect(check.result).to eq(status) }
    end

    context 'database unavailable' do
      let(:service_status) { 'failed' }
      let(:database_status) { 'failed' }

      before do
        expect(ActiveRecord::Base).to receive(:connection).and_return(nil)
      end

      specify { expect(check.result).to eq(status) }
    end

    describe 'Courtfinder API status' do
      context 'when CourtfinderAPI.status.is_ok?' do
        let(:courtfinder_api_is_ok){ true }

        specify { expect(check.result).to eq(status) }
      end
      context 'when it is not OK' do
        let(:courtfinder_api_is_ok){ false }
        let(:service_status) { 'failed' }
        let(:courtfinder_status) { 'failed' }

        specify { expect(check.result).to eq(status) }
      end
    end
  end
end
