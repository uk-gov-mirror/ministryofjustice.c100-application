require 'rails_helper'

describe C100App::CourtPostcodeChecker do
  describe '#court_slugs_blocklist' do
    it 'returns the blocklisted slugs' do
      expect(
        subject.court_slugs_blocklist
      ).to match_array(%w[blocklisted-slug-example])
    end
  end

  describe '#court_for' do
    let(:dummy_court_objects) do
      [{ "courtSlug" => "dummy-court-slug" }]
    end

    context 'when the NewCourtfinderApi does not throw an error' do
      before do
        expect_any_instance_of(C100App::NewCourtfinderApi).to receive(:court_for).once.with(
          described_class::AREA_OF_LAW, 'mypostcode'
        ).and_return(dummy_court_objects)
      end

      context 'and a candidate court was found' do
        before do
          expect_any_instance_of(C100App::NewCourtfinderApi).to receive(:court_lookup).once.with(
            'dummy-court-slug'
          ).and_return(candidate_court)
        end

        let(:candidate_court) { {"slug" => "dummy-court-slug", 'open' => true} }
        let(:choosen_court) { 'choosen court' }
        let(:court) { instance_double(Court) }

        it 'returns a Court instance' do
          expect(Court).to receive(:create_or_refresh).with(candidate_court).and_return(court)
          expect(subject.send(:court_for, 'mypostcode')).to eq(court)
        end
      end

      context 'and a candidate court was not found' do
        before do
          expect_any_instance_of(C100App::NewCourtfinderApi).to receive(:court_lookup).once.with('dummy-court-slug').and_return(nil)
        end

        it 'returns nil' do
          expect(Court).not_to receive(:create_or_refresh)
          expect(subject.send(:court_for, 'mypostcode')).to be_nil
        end
      end

      context 'and a candidate court was found but it is closed' do
        before do
          expect_any_instance_of(C100App::NewCourtfinderApi).to receive(:court_lookup).once.with(
            'dummy-court-slug'
          ).and_return(candidate_court)
        end

        let(:candidate_court) { {"slug" => "dummy-court-slug", "open" => false} }
        let(:choosen_court) { 'choosen court' }
        let(:court) { instance_double(Court) }

        it 'returns nil' do
          expect(Court).not_to receive(:create_or_refresh)
          expect(subject.send(:court_for, 'mypostcode')).to be_nil
        end
      end
    end

    context 'when the NewCourtfinderApi throws an error' do
      before do
        allow_any_instance_of(C100App::NewCourtfinderApi).to receive(:court_for).and_raise(StandardError)
      end

      it 'allows the error to propagate out un-caught' do
        expect { subject.send(:court_for, 'blah') }.to raise_error
      end
    end


    context 'when the postcode is in Scotland or NI' do
      it 'returns nil' do
        expect(subject.send(:court_for, 'DD4 7SN')).to be_nil
      end
    end
  end

  describe '#choose_from' do
    let(:result) { subject.send(:choose_from, arg) }

    context 'given an array of court slugs' do
      context 'when the first slug is not blocklisted' do
        let(:arg) do
          %w[a-valid-slug another-slug]
        end

        it 'returns the first slug' do
          expect(result).to eq('a-valid-slug')
        end
      end

      context 'when the first slug is blocklisted' do
        let(:arg) do
          %w[blocklisted-slug-example a-valid-slug]
        end

        it 'returns the first non-blocklisted slug' do
          expect(result).to eq('a-valid-slug')
        end
      end

      context 'when all slugs are blocklisted' do
        let(:arg) do
          ['blocklisted-slug-example']
        end

        it 'returns nil' do
          expect(result).to be_nil
        end
      end

      context 'when the array is empty' do
        let(:arg) { [] }

        it 'returns nil' do
          expect(result).to be_nil
        end
      end
    end
  end

  describe '#scotland_or_ni' do
    it 'returns false for English postcodes' do
      %w(BH BS DT EX GL HR PL TA TQ TR WR BN BR CR CT DA KT ME RH SM
      TN TW BA GU HA HP OX PO RG SL SN SO SP UB E EC N NW SE SW W
      WC BB BL CA CW FY L LA M OL PR SK SY TF WA WN CH BD DH DL DN
      HD HG HU HX LN LS NE S SR TS WF YO B CV DE DY LE NG NN ST WS
      WV AL CB CM CO EN IG IP LU MK NR PE RM SG SS WD TD12 TD15
      ).each do |area|
        expect(subject.send(:scotland_or_ni, area)).to be(false),
          "error in #{area}"
      end
    end
    it 'returns false for Welsh postcodes' do
      %w(CF LD LL NP SA).each do |area|
        expect(subject.send(:scotland_or_ni, area)).to be(false),
          "error in #{area}"
      end
    end
    it 'returns true for Scottish postcodes' do
      %w(AB DD DG EH FK G1 HS IV KA KW KY ML PA PH TD1 TD3 TD11 TD22 ZE).each do |area|
        expect(subject.send(:scotland_or_ni, area)).to be(true),
          "error in #{area}"
      end
    end
    it 'returns true for Northern Irish postcodes' do
      %w(BT).each do |area|
        expect(subject.send(:scotland_or_ni, area)).to be(true),
          "error in #{area}"
      end
    end
  end
end
