require "rails_helper"

RSpec.describe SubmissionMailer do
  describe '#attachment_contents' do
    context 'given a file path' do
      it 'reads the file' do
        expect(File).to receive(:read).at_least(:once).with('/my/path').and_return('content')
        subject.send(:attachment_contents, '/my/path')
      end
    end
  end
end
