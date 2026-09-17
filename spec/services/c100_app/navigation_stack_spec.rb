require 'rails_helper'

RSpec.describe C100App::NavigationStack do
  subject { described_class.new(navigation_stack) }

  let(:navigation_stack) { [] }

  describe '#updated_for' do
    subject { described_class.new(navigation_stack).updated_for(current_path) }

    let(:current_path) { '/dummy_step' }

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'adds the current page to the stack' do
        expect(subject).to eq(['/dummy_step'])
      end
    end

    context 'when the current page is already on the stack' do
      let(:navigation_stack) { %w[/foo /bar /dummy_step /baz] }

      it 'rewinds the stack to the current page' do
        expect(subject).to eq(%w[/foo /bar /dummy_step])
      end
    end

    context 'when the current page is not on the stack' do
      let(:navigation_stack) { %w[/foo /bar /baz] }

      it 'adds the current page to the end of the stack' do
        expect(subject).to eq(%w[/foo /bar /baz /dummy_step])
      end
    end

    context 'when coming from cya' do
      context 'for a complete stack' do
        let(:navigation_stack) do
          %w[
            /foo
            /bar
            /dummy_step
            /steps/application/payment
            /steps/application/check_your_answers
          ]
        end

        context 'when the target step can fast forward' do
          let(:current_path) { '/steps/application/details' }

          it 'does not change the stack' do
            expect(subject).to eq(navigation_stack)
          end
        end

        context 'when the target step cannot fast forward' do
          it 'changes the stack' do
            expect(subject).to eq(%w[
              /foo
              /bar
              /dummy_step
            ])
          end
        end
      end

      context 'for an incomplete stack' do
        let(:navigation_stack) do
          %w[
            /foo
            /bar
            /dummy_step
            /another_step
            /steps/application/check_your_answers
          ]
        end

        it 'changes the stack' do
          expect(subject).to eq(%w[
            /foo
            /bar
            /dummy_step
          ])
        end
      end
    end
  end

  describe '#previous_path' do
    subject { described_class.new(navigation_stack).previous_path }

    context 'when the stack is empty' do
      let(:navigation_stack) { [] }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the stack has one element' do
      let(:navigation_stack) { ['/foo'] }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end

    context 'when the stack has multiple elements' do
      let(:navigation_stack) { %w[/foo /bar /baz] }

      it 'returns the previous path' do
        expect(subject).to eq('/bar')
      end
    end
  end

  describe '#progressed?' do
    subject { described_class.new(navigation_stack).progressed? }

    context 'when the stack has two or fewer elements' do
      let(:navigation_stack) { %w[/foo /bar] }

      it 'returns false' do
        expect(subject).to be(false)
      end
    end

    context 'when the stack has more than two elements' do
      let(:navigation_stack) { %w[/foo /bar /baz] }

      it 'returns true' do
        expect(subject).to be(true)
      end
    end
  end

  describe '#fast_forward_to_cya?' do
    subject do
      described_class.new(navigation_stack).fast_forward_to_cya?(current_path)
    end

    let(:current_path) { '/steps/application/details' }

    context 'when the stack ends with the complete CYA stack' do
      let(:navigation_stack) do
        %w[
          /foo
          /bar
          /steps/application/payment
          /steps/application/check_your_answers
        ]
      end

      it 'returns true for a fast-forward step' do
        expect(subject).to be(true)
      end

      context 'when the current path cannot fast forward' do
        let(:current_path) { '/steps/application/something_else' }

        it 'returns false' do
          expect(subject).to be(false)
        end
      end
    end

    context 'when the stack does not end with the complete CYA stack' do
      let(:navigation_stack) do
        %w[
          /foo
          /bar
          /dummy_step
          /steps/application/check_your_answers
        ]
      end

      it 'returns false' do
        expect(subject).to be(false)
      end
    end
  end
end
