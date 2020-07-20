require 'rails_helper'

RSpec.describe 'steps/completion/what_next/show', type: :view do
  let(:consent_order) { GenericYesNo::YES }
  let(:c100_application) { C100Application.new(id: '449362af-0bc3-4953-82a7-1363d479b876', created_at: Time.at(0), consent_order: consent_order) }

  before do
    assign(:c100_application, c100_application)

    assign(
        :court,
        double('Court',
               name: 'Test court',
               email: 'court@example.com',
               slug: 'test-court',
               full_address: ['10', 'downing', 'st']
        )
    )

    render
  end

  context 'when application is a consent order' do
    it 'should render `with_consent_order` partial' do
      expect(view).to_not render_template('steps/completion/what_next/_without_consent_order')
      expect(view).to render_template('steps/completion/what_next/_with_consent_order')
    end
  end

  context 'when application is not a consent order' do
    let(:consent_order) { GenericYesNo::NO }

    it 'should render `without_consent_order` partial' do
      expect(view).to_not render_template('steps/completion/what_next/_with_consent_order')
      expect(view).to render_template('steps/completion/what_next/_without_consent_order')
    end
  end

end
