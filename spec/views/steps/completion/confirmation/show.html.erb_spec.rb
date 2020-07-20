require 'rails_helper'

RSpec.describe 'steps/completion/confirmation/show', type: :view do
  let(:consent_order) { GenericYesNo::YES }
  let(:under_age) { true }
  let(:applicants_collection_double) { double(under_age?: under_age) }
  let(:c100_application) { C100Application.new(id: '449362af-0bc3-4953-82a7-1363d479b876', created_at: Time.at(0), consent_order: consent_order) }

  before do
    allow(c100_application).to receive(:applicants).and_return(applicants_collection_double)

    assign(:c100_application, c100_application)

    assign(
      :court,
      double('Court',
        name: 'Test court',
        email: 'court@example.com',
        slug: 'test-court'
      )
    )

    render
  end

  context 'when applicant is under age' do
    it 'should render the `under_age_section` partial' do
      expect(view).to render_template('steps/shared/_under_age_section')
    end

    context 'when application is a consent order' do
      it 'should render `consent_order_section` partial' do
        expect(view).to render_template('steps/completion/confirmation/_consent_order_section')
      end
    end

    context 'when application is not a consent order' do
      let(:consent_order) { GenericYesNo::NO }

      it 'should not render `consent_order_section`' do
        expect(view).to_not render_template('steps/completion/confirmation/_consent_order_section')
      end
    end
  end

  context 'when applicant is an adult' do
    let(:under_age) { false }

    it 'should not render the `under_age_section` partial' do
      expect(view).to_not render_template('steps/shared/_under_age_section')
    end

    context 'when application is a consent order' do
      it 'should render `consent_order_section` partial' do
        expect(view).to render_template('steps/completion/confirmation/_consent_order_section')
      end
    end

    context 'when application is not a consent order' do
      let(:consent_order) { GenericYesNo::NO }

      it 'should not render `consent_order_section`' do
        expect(view).to_not render_template('steps/completion/confirmation/_consent_order_section')
      end
    end
  end
end
