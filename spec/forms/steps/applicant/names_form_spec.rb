require 'spec_helper'

RSpec.describe Steps::Applicant::NamesForm do
  let(:arguments) { {
    c100_application: c100_application,
    names_attributes: names_attributes,
    new_name: new_name
  } }

  let(:c100_application) { instance_double(C100Application, applicants: record_collection) }
  let(:record_collection) { double('record_collection', empty?: false, create: true) }

  let(:names_attributes) { {} }
  let(:new_name) { 'John' }

  subject { described_class.new(arguments) }

  describe '#save' do
    context 'when no c100_application is associated with the form' do
      let(:c100_application) { nil }

      it 'raises an error' do
        expect { subject.save }.to raise_error(BaseForm::C100ApplicationNotFound)
      end
    end

    context 'validations on `new_name`' do
      context 'when there are no other children names' do
        it {
          expect(record_collection).to receive(:empty?).and_return(true)
          should validate_presence_of(:new_name)
        }
      end

      context 'when there are existing children names' do
        it {
          expect(record_collection).to receive(:empty?).and_return(false)
          should_not validate_presence_of(:new_name)
        }
      end
    end

    context 'when form is valid' do
      context 'adding new names' do
        let(:new_name) { 'Gareth' }

        it 'it creates a new child with the provided name' do
          expect(record_collection).to receive(:create).with(
            full_name: 'Gareth'
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'if the new name is blank, ignore it' do
        let(:new_name) { '' }

        it 'it creates a new child with the provided name' do
          expect(record_collection).not_to receive(:create)
          expect(subject.save).to be(true)
        end
      end

      context 'updating existing names' do
        let(:new_name) { nil }
        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'full_name' => 'Paul'},
            '1' => {'id' => 'uuid2', 'full_name' => 'Alex'}
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'full_name' => 'Paul'}
          ).and_return(true)

          expect(record_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'full_name' => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'ignore blank names when updating' do
        let(:new_name) { nil }
        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'full_name' => ''},
            '1' => {'id' => 'uuid2', 'full_name' => 'Alex'}
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).not_to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'full_name' => ''}
          )

          expect(record_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'full_name' => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
