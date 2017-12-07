RSpec.shared_examples 'a names CRUD form' do |form_class, options = {}|
  let(:collection_name) { ActiveModel::Name.new(form_class).collection }
  let(:name_attribute)  { options.fetch(:name_attribute, :full_name).to_s }

  let(:arguments) { {
    c100_application: c100_application,
    names_attributes: names_attributes,
    new_name: new_name
  } }

  let(:c100_application) { instance_double(C100Application, collection_name => record_collection) }
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
      context 'when there are no other records' do
        it {
          expect(record_collection).to receive(:empty?).and_return(true)
          should validate_presence_of(:new_name)
        }
      end

      context 'when there are existing records' do
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
            name_attribute.to_sym => 'Gareth'
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
            '0' => {'id' => 'uuid1', name_attribute => 'Paul'},
            '1' => {'id' => 'uuid2', name_attribute => 'Alex'}
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).to receive(:update).with(
            'uuid1', {'id' => 'uuid1', name_attribute => 'Paul'}
          ).and_return(true)

          expect(record_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', name_attribute => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end

      context 'ignore blank names when updating' do
        let(:new_name) { nil }
        let(:names_attributes) {
          {
            '0' => {'id' => 'uuid1', name_attribute => ''},
            '1' => {'id' => 'uuid2', name_attribute => 'Alex'}
          }
        }

        it 'it updates the names of the people' do
          expect(record_collection).not_to receive(:update).with(
            'uuid1', {'id' => 'uuid1', name_attribute => ''}
          )

          expect(record_collection).to receive(:update).with(
            'uuid2', {'id' => 'uuid2', name_attribute => 'Alex'}
          ).and_return(true)

          expect(subject.save).to be(true)
        end
      end
    end
  end
end
