require 'spec_helper'

describe Summary::HtmlPresenter do
  let(:c100_application) { instance_double(C100Application) }
  subject { described_class.new(c100_application) }

  describe '#sections' do
    it 'has the right sections in the right order' do
      expect(subject.sections.count).to eq(0)
    end
  end
end
