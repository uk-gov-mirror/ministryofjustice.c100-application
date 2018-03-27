require 'rails_helper'

RSpec.describe Steps::CourtOrders::DetailsController, type: :controller do
  it_behaves_like 'an intermediate step controller', Steps::CourtOrders::DetailsForm, C100App::CourtOrdersDecisionTree


  context 'XSS vulnerability in date fields' do
    render_views
    describe 'POSTing to details' do
      let(:values){
        {
          "steps_court_orders_details_form"=>{
            "non_molestation"=>"yes",
            "non_molestation_issue_date_dd"=>"1",
            "non_molestation_issue_date_mm"=>"1",
            "non_molestation_issue_date_yyyy"=>yyyy,
            "non_molestation_length"=>"",
            "non_molestation_court_name"=>""
          }
        }
      }
      let(:existing_case) { C100Application.create(status: :in_progress) }
      let(:xss_payload){ "<script type=""text/javascript"">alert('XSS!')</script>" }

      before do
        put :update, params: values, session: { c100_application_id: existing_case.id }
      end

      context 'with a missing yyyy value' do
        let(:yyyy){ "" }

        it 'renders the edit form' do
          expect(response).to render_template(:edit)
        end

        describe 'the response' do
          let(:body){ response.body }

          it 'does not show an error on the YYYY value' do
            expect(response).to_not have_content('gov_uk_date_error')
          end

          it 'contains the YYYY field with a value attribute' do
            expect(body).to match( /steps_court_orders_details_form_non_molestation_issue_date_yyyy[^>]+value/ )
          end

          it 'does not contain an injected <script tag' do
            expect(body).to_not include(xss_payload)
          end
        end
      end

      context 'with an attempted XSS injection payload' do
        let(:yyyy){ """>#{xss_payload}" }

        it 'renders the edit form' do
          expect(response).to render_template(:edit)
        end

        it 'does not show an error on the YYYY value' do
          expect(response).to_not have_content('gov_uk_date_error')
        end

        describe 'the response' do
          let(:body){ response.body }

          it 'does not contain a <script tag' do
            expect(body).to_not include(xss_payload)
          end
        end
      end
    end
  end
end
