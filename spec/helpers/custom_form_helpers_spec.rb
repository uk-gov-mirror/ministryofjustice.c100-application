require 'rails_helper'

class TestHelper < ActionView::Base
  #:nocov:
  def user_signed_in?
    false
  end
  #:nocov:
end

# The module `CustomFormHelpers` gets mixed in and extends the helpers already
# provided by `GOVUKDesignSystemFormBuilder::FormBuilder`. These are app-specific
# form helpers so can be coupled to application business and logic.
#
# Refer to: `config/initializers/form_builder.rb`
#
RSpec.describe GOVUKDesignSystemFormBuilder::FormBuilder do
  let(:helper) { TestHelper.new }

  describe '#continue_button' do
    let(:c100_application) { C100Application.new(status: :in_progress) }
    let(:builder) { described_class.new :applicant, Applicant.new, helper, {} }
    let(:html_output) { builder.continue_button }

    before do
      allow(helper).to receive(:current_c100_application).and_return(c100_application)
    end

    context 'no c100 application yet' do
      let(:c100_application) { nil }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<input type="submit" name="commit" value="Continue" class="govuk-button" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Continue" />')
      end
    end

    context 'for an application in screening' do
      let(:c100_application) { C100Application.new(status: :screening) }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<input type="submit" name="commit" value="Continue" class="govuk-button" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Continue" />')
      end
    end

    context 'for a logged in user' do
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'outputs the save and continue button' do
        expect(
          html_output
        ).to eq('<input type="submit" name="commit" value="Save and continue" class="govuk-button" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Save and continue" />')
      end

      context 'with button value customised' do
        let(:html_output) { builder.continue_button save_and_continue: :confirm_and_finish }

        it 'outputs the custom value' do
          expect(
            html_output
          ).to eq('<input type="submit" name="commit" value="Confirm and finish" class="govuk-button" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Confirm and finish" />')
        end
      end
    end

    context 'for a logged out user' do
      it 'outputs the continue button together with a save draft button' do
        expect(
          html_output
        ).to eq('<input type="submit" name="commit" value="Continue" class="govuk-button govuk-!-margin-right-1" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Continue" /><input type="submit" name="commit_draft" value="Save and come back later" class="govuk-button govuk-button--secondary" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Save and come back later">')
      end

      context 'with button value customised' do
        let(:html_output) { builder.continue_button continue: :confirm_and_finish }

        it 'outputs the custom value' do
          expect(
            html_output
          ).to eq('<input type="submit" name="commit" value="Confirm and finish" class="govuk-button govuk-!-margin-right-1" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Confirm and finish" /><input type="submit" name="commit_draft" value="Save and come back later" class="govuk-button govuk-button--secondary" formnovalidate="formnovalidate" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Save and come back later">')
        end
      end
    end
  end
end
