require 'rails_helper'

RSpec.describe CourtContactDetails do
  let(:test_class) { Court }

  subject {
    test_class.new(
      id: 'court-slug',
      name: 'Court name',
      email: 'court@example',
      address: address,
    )
  }

  let(:address) { 'address' }

  describe 'Centralised courts (smoke test)' do
    it 'returns the list of slugs taking part in the centralisation' do
      expect(
        subject.send(:centralised_slugs)
      ).to match_array(%w(
        brighton-county-court
        chelmsford-county-and-family-court
        leeds-combined-court-centre
        medway-county-court-and-family-court
        west-london-family-court
      ))
    end
  end

  describe '#centralised?' do
    before do
      allow(subject).to receive(:slug).and_return(slug)
    end

    context 'for a centralised court' do
      let(:slug) { 'west-london-family-court' }

      it 'returns true' do
        expect(subject.centralised?).to eq(true)
      end
    end

    context 'for a non-centralised court' do
      let(:slug) { 'derby-combined-court-centre' }

      it 'returns false' do
        expect(subject.centralised?).to eq(false)
      end
    end
  end

  describe '#full_address' do
    let(:address) { { 'address_lines' => address_lines, 'town' => 'town', 'postcode' => 'postcode' } }
    let(:address_lines){ ['line 1', 'line 2'] }

    before do
      allow(subject).to receive(:centralised?).and_return(centralised)
    end

    context 'for a centralised court' do
      let(:centralised) { true }

      it 'returns the central hub postal address' do
        expect(
          subject.full_address
        ).to eq(['C100 Applications', 'PO Box 1792', 'Southampton', 'SO15 9GG', 'DX: 135986 Southampton 32'])
      end
    end

    context 'for a not yet centralised court' do
      let(:centralised) { false }

      it 'returns a flattened array of name, address_lines, town and postcode' do
        expect(subject.full_address).to eq(['Court name', 'line 1', 'line 2', 'town', 'postcode'])
      end

      context 'when any lines are duplicated' do
        let(:address_lines){ ['Court name', 'postcode'] }

        it 'removes the duplicates' do
          expect(subject.full_address).to eq(['Court name', 'postcode', 'town'])
        end
      end

      context 'when any lines are blank' do
        let(:address_lines){ ['line 1', ''] }

        it 'removes the blank lines' do
          expect(subject.full_address).to eq(['Court name', 'line 1', 'town', 'postcode'])
        end
      end
    end
  end

  describe '#documents_email' do
    before do
      allow(subject).to receive(:centralised?).and_return(centralised)
    end

    context 'for a centralised court' do
      let(:centralised) { true }

      it 'returns the central hub email address' do
        expect(subject.documents_email).to eq('C100applications@justice.gov.uk')
      end
    end

    context 'for a not yet centralised court' do
      let(:centralised) { false }

      it 'returns the email address of the court' do
        expect(subject.documents_email).to eq('court@example')
      end
    end
  end
end
