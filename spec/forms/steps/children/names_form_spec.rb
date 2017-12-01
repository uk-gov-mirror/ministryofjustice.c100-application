require 'spec_helper'

RSpec.describe Steps::Children::NamesForm do
  let(:arguments) { {
    c100_application: c100_application,
    names_attributes: names_attributes,
    new_name: new_name
  } }

  let(:c100_application) { instance_double(C100Application, children: children_collection) }
  let(:children_collection) { double('children_collection', empty?: false, create: true) }
  let(:child) { double('Child') }

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
        let(:children_collection) { [] }
        it { should validate_presence_of(:new_name) }
      end

      context 'when there are existing children names' do
        let(:children_collection) { ['whatever'] }
        it { should_not validate_presence_of(:new_name) }
      end
    end

    context 'when form is valid' do
      context 'adding new children names' do
        let(:new_name) { 'Gareth' }

        it 'it creates a new child with the provided name' do
          expect(children_collection).to receive(:create).with(
            name: 'Gareth'
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'if the new name is blank, ignore it' do
        let(:new_name) { '' }

        it 'it creates a new child with the provided name' do
          expect(children_collection).not_to receive(:create)
          expect(subject.save).to be(true)
        end
      end

      context 'updating existing children names' do
        let(:new_name) { nil }
        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'name' => 'Paul'},
            '1' => {'id' => 'uuid2', 'name' => 'Alex'}
          }
        }

        it 'it updates the names of the children' do
          expect(children_collection).to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'name' => 'Paul'}
          ).and_return(true)

          expect(children_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'name' => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'ignore blank names when updating' do
        let(:new_name) { nil }
        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', 'name' => ''},
            '1' => {'id' => 'uuid2', 'name' => 'Alex'}
          }
        }

        it 'it updates the names of the children' do
          expect(children_collection).not_to receive(:update).with(
            'uuid1', {'id' => 'uuid1', 'name' => ''}
          )

          expect(children_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', 'name' => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
