require 'rails_helper'

describe C100App::CourtPostcodeChecker do
  describe '#court_slugs_blocklist' do
    it 'returns the blocklisted slugs' do
      expect(
        subject.court_slugs_blocklist
      ).to match_array(%w(
        blocklisted-slug-example
      ))
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
    let(:result){ subject.send(:choose_from,arg) }

    context 'given an array of hashes' do
      context 'with at least one hash that has a :slug key' do
        context 'when the first slug is not blocklisted' do
          let(:arg){
            [
              {key: 'value'},
              {slug: 'a-valid-slug'},
              {slug: 'another-slug'},
            ]
          }

          it 'returns the hash' do
            expect(result).to eq({slug: 'a-valid-slug'})
          end
        end

        context 'when the first slug is blocklisted' do
          let(:arg){
            [
              {key: 'value'},
              {slug: 'blocklisted-slug-example'},
              {slug: 'another-slug'},
            ]
          }
          it 'returns nil' do
            expect(result).to eq(nil)
          end
        end
      end

      context 'with no hash that has a :slug key, but at least one that has a "slug" key' do
        context 'when the first slug is not blocklisted' do
          let(:arg){
            [
              {key: 'value'},
              {'slug' => 'a-valid-slug'},
              {'slug' => 'another-slug'},
            ]
          }

          it 'returns the hash' do
            expect(result).to eq({'slug' => 'a-valid-slug'})
          end
        end

        context 'when the first slug is blocklisted' do
          let(:arg){
            [
              {key: 'value'},
              {'slug' => 'blocklisted-slug-example'},
              {'slug' => 'another-slug'},
            ]
          }

          it 'returns nil' do
            expect(result).to eq(nil)
          end
        end
      end
    end
  end
end
