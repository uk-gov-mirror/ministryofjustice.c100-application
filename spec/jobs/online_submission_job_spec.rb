require 'rails_helper'

RSpec.describe OnlineSubmissionJob, type: :job do
  let(:c100_application) { instance_double(C100Application) }

  before do
    ActiveJob::Base.queue_adapter = :test
  end

  describe '#perform' do
    it 'calls the `SendApplicationToCourt` service to process the application' do
      expect_any_instance_of(C100App::OnlineSubmission).to receive(:process)
      OnlineSubmissionJob.perform_now(c100_application)
    end
  end
end
