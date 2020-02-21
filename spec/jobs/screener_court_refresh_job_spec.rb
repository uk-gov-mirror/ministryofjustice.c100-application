require 'rails_helper'

RSpec.describe ScreenerCourtRefreshJob, type: :job do
  let(:screener_answers) { instance_double(ScreenerAnswers) }

  describe '#perform' do
    it 'calls `refresh_local_court!` to refresh the local court' do
      expect(screener_answers).to receive(:refresh_local_court!)
      described_class.perform_now(screener_answers)
    end
  end
end
