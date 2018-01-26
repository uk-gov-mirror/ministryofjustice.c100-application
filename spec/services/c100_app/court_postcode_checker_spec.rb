require 'rails_helper'

describe C100App::CourtPostcodeChecker do
  describe '#courts_for' do
    before do
      allow(subject).to receive(:court_for).and_return( 'call1', 'call2', 'call3' )
    end

    context 'given several postcodes separated by "\n"' do
      let(:postcodes) {
        "A1AAA\nB1BBB\nC1CCC"
      }
      it 'calls court_for with each postcode' do
        expect(subject).to receive(:court_for).once.with('A1AAA')
        expect(subject).to receive(:court_for).once.with('B1BBB')
        expect(subject).to receive(:court_for).once.with('C1CCC')
        subject.courts_for(postcodes)
      end
    end
    context 'when the given postcodes contain blank lines' do
      let(:postcodes){
        "\n\nA1AAA\n\nB1BBB\n\n"
      }
      it 'does not call court_for with the blank lines' do
        expect(subject).to receive(:court_for).once.with('A1AAA')
        expect(subject).to receive(:court_for).once.with('B1BBB')
        subject.courts_for(postcodes)
      end
    end
    it 'returns the results of the court_for calls' do
      expect(subject.courts_for("A1AAA\nB1BBB")).to eq(['call1', 'call2'])
    end
  end

  describe '#court_for' do
    let(:dummy_court_objects){
      [{'slug' => 'dummy-court-slug'}]
    }

    it 'calls court_for on the CourtfinderAPI, passing the AREA_OF_LAW and given postcode' do
      expect_any_instance_of(C100App::CourtfinderAPI).to receive(:court_for).
                                                    once.
                                                    with(subject.class::AREA_OF_LAW, 'mypostcode').
                                                    and_return(dummy_court_objects)
      subject.send(:court_for, 'mypostcode')
    end

    context 'when the CourtfinderAPI does not throw an error' do
      before do
        allow_any_instance_of(C100App::CourtfinderAPI).to receive(:court_for).and_return(dummy_court_objects)
      end

      it 'calls choose_from with the returned objects' do
        expect(subject).to receive(:choose_from).with(dummy_court_objects)
        subject.send(:court_for, 'mypostcode')
      end

      it 'returns the result of choose_from' do
        allow(subject).to receive(:choose_from).and_return('chosen court')
        expect(subject.send(:court_for, 'mypostcode')).to eq('chosen court')
      end
    end

    context 'when the CourtfinderAPI throws an error' do
      before do
        allow_any_instance_of(C100App::CourtfinderAPI).to receive(:court_for).and_raise(Exception)
      end

      it 'allows the error to propagate out un-caught' do
        expect{ subject.send(:court_for, 'blah') }.to raise_error
      end
    end
  end

  describe '#choose_from' do
    context 'given an array of hashes' do
      let(:arg){
        [
          {key: 'value'},
          {slug: 'slug-1'},
          {slug: C100App::CourtPostcodeChecker::COURT_SLUGS_USING_THIS_APP.first}
        ]
      }

      it 'returns the first hash whose :slug is in the COURT_SLUGS_USING_THIS_APP' do
        expect(subject.send(:choose_from,arg)).to eq({slug: C100App::CourtPostcodeChecker::COURT_SLUGS_USING_THIS_APP.first})
      end
    end
  end
end