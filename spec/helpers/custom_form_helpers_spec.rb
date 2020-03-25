require 'rails_helper'

class TestHelper < ActionView::Base
  #:nocov:
  def user_signed_in?
    false
  end
  #:nocov:
end

# The module `CustomFormHelpers` gets mixed in and extends the helpers already
# provided by `GovukElementsFormBuilder::FormBuilder`. These are app-specific
# form helpers so can be coupled to application business and logic.
#
# Refer to: `config/initializers/form_builder.rb`
#
RSpec.describe GovukElementsFormBuilder::FormBuilder do
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
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></div>')
      end
    end

    context 'for an application in screening' do
      let(:c100_application) { C100Application.new(status: :screening) }

      it 'outputs the continue button' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /></div>')
      end
    end

    context 'for a logged in user' do
      before do
        allow(helper).to receive(:user_signed_in?).and_return(true)
      end

      it 'outputs the save and continue button' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Save and continue" class="button" data-disable-with="Save and continue" /></div>')
      end

      context 'with button value customised' do
        let(:html_output) { builder.continue_button save_and_continue: :confirm_and_finish }

        it 'outputs the custom value' do
          expect(
            html_output
          ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Confirm and finish" class="button" data-disable-with="Confirm and finish" /></div>')
        end
      end
    end

    context 'for a logged out user' do
      it 'outputs the continue button with a link to sign-up' do
        expect(
          html_output
        ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Continue" class="button" data-disable-with="Continue" /><input type="submit" name="commit_draft" value="Save and come back later" class="button button-secondary commit-draft-link" data-disable-with="Save and come back later" /></div>')
      end

      context 'with button value customised' do
        let(:html_output) { builder.continue_button continue: :confirm_and_finish }

        it 'outputs the custom value' do
          expect(
            html_output
          ).to eq('<div class="form-submit"><input type="submit" name="commit" value="Confirm and finish" class="button" data-disable-with="Confirm and finish" /><input type="submit" name="commit_draft" value="Save and come back later" class="button button-secondary commit-draft-link" data-disable-with="Save and come back later" /></div>')
        end
      end
    end
  end

  describe '#single_check_box' do
    let(:c100_application) { C100Application.new }
    let(:builder) { described_class.new :c100_application, c100_application, helper, {} }
    let(:html_output) { builder.single_check_box(:miam_acknowledgement) }

    it 'outputs the check box' do
      expect(
        html_output
      ).to eq('<div class="multiple-choice single-cb"><input name="c100_application[miam_acknowledgement]" type="hidden" value="0" /><input type="checkbox" value="1" name="c100_application[miam_acknowledgement]" id="c100_application_miam_acknowledgement" /><label for="c100_application_miam_acknowledgement">Miam acknowledgement</label></div>')
    end

    context 'when there are errors' do
      before do
        c100_application.errors.add(:miam_acknowledgement, :blank)
      end

      it 'outputs the check box with the error markup' do
        expect(
          html_output
        ).to eq('<div class="multiple-choice single-cb" id="error_c100_application_miam_acknowledgement"><input name="c100_application[miam_acknowledgement]" type="hidden" value="0" /><input aria-describedby="error_message_c100_application_miam_acknowledgement" type="checkbox" value="1" name="c100_application[miam_acknowledgement]" id="c100_application_miam_acknowledgement" /><label for="c100_application_miam_acknowledgement">Miam acknowledgement<span class="error-message" id="error_message_c100_application_miam_acknowledgement">Enter an answer</span></label></div>')
      end
    end
  end
end
