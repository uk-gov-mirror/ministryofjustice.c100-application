# :nocov:
class ActionDispatch::Routing::Mapper
  def edit_step(name, opts = {}, &block)
    resource name,
             only:       opts.fetch(:only, [:edit, :update]),
             controller: name,
             path_names: { edit: '' } do; block.call if block_given?; end
  end

  def crud_step(name, opts = {})
    edit_step name, opts do
      resources only: opts.fetch(:only, [:edit, :update, :destroy]),
                controller: name,
                path_names: { edit: '' }
    end
  end

  def show_step(name)
    resource name,
             only:       [:show],
             controller: name
  end

  def edit_routes(path)
    get   path, action: :edit
    put   path, action: :update
    patch path, action: :update
  end
end
# :nocov:

Rails.application.routes.draw do
  devise_for :users,
             controllers: {
               registrations: 'users/registrations',
               passwords: 'users/passwords',
               sessions: 'users/logins'
             },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout'
             }

  namespace :users do
    devise_scope :user do
      get 'login/logged_out',        to: 'logins#logged_out'
      get 'login/save_confirmation', to: 'logins#save_confirmation'

      get 'password/reset_sent',         to: 'passwords#reset_sent'
      get 'password/reset_confirmation', to: 'passwords#reset_confirmation'

      get 'registration/save_confirmation',   to: 'registrations#save_confirmation'
      get 'registration/update_confirmation', to: 'registrations#update_confirmation'
    end

    resources :drafts, only: [:index, :destroy] do
      get :resume, on: :member
    end
  end

  namespace :steps do
    namespace :screener do
      show_step :start
      edit_step :postcode
      show_step :error_but_continue
      show_step :no_court_found
      edit_step :urgency
      show_step :urgent_exit
      edit_step :parent
      show_step :parent_exit
      edit_step :over18
      show_step :over18_exit
      edit_step :legal_representation
      show_step :legal_representation_exit
      edit_step :written_agreement
      show_step :written_agreement_exit
      edit_step :email_consent
      show_step :done
    end
    namespace :application do
      edit_step :previous_proceedings
      edit_step :court_proceedings
      edit_step :without_notice
      edit_step :without_notice_details
      edit_step :litigation_capacity
      edit_step :litigation_capacity_details
      edit_step :special_assistance
      edit_step :special_arrangements
      edit_step :details
      edit_step :language
      edit_step :intermediary
      edit_step :help_paying
      edit_step :declaration
      edit_step :check_your_answers
    end
    namespace :petition do
      edit_step :orders
      show_step :playback
      edit_step :protection
    end
    namespace :miam do
      edit_step :consent_order
      show_step :consent_order_sought
      edit_step :child_protection_cases
      show_step :child_protection_info
      edit_step :acknowledgement
      edit_step :attended
      edit_step :exemption_claim
      edit_step :certification
      edit_step :certification_date
      show_step :certification_expired_info
      edit_step :certification_details
      show_step :certification_confirmation
    end
    namespace :miam_exemptions do
      edit_step :domestic
      edit_step :protection
      edit_step :urgency
      edit_step :adr
      edit_step :misc
      show_step :reasons_playback
      show_step :safety_playback
      show_step :exit_page
    end
    namespace :abduction do
      edit_step :international
      edit_step :children_have_passport
      edit_step :passport_details
      edit_step :previous_attempt
      edit_step :previous_attempt_details
      edit_step :risk_details
    end
    namespace :safety_questions do
      show_step :start
      edit_step :address_confidentiality
      edit_step :risk_of_abduction
      edit_step :substance_abuse
      edit_step :substance_abuse_details
      edit_step :children_abuse
      edit_step :domestic_abuse
      edit_step :other_abuse
    end
    namespace :abuse_concerns do
      show_step :start
      show_step :children_info
      show_step :applicant_info
      edit_step :question do
        get '/:subject/:kind', action: :edit
      end
      edit_step :details do
        get '/:subject/:kind', action: :edit
      end
      edit_step :contact
    end
    namespace :court_orders do
      edit_step :has_orders
      edit_step :details
    end
    namespace :alternatives do
      show_step :start
      edit_step :negotiation_tools
      edit_step :mediation
      edit_step :lawyer_negotiation
      edit_step :collaborative_law
      edit_step :court
    end
    namespace :children do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :orders, only: [:edit, :update]
      edit_step :additional_details
      edit_step :has_other_children
      crud_step :residence, only: [:edit, :update]
    end
    namespace :other_children do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
    end
    namespace :applicant do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :under_age,        only: [:edit, :update]
      crud_step :contact_details,  only: [:edit, :update]
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :respondent do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :under_age,        only: [:edit, :update]
      crud_step :contact_details,  only: [:edit, :update]
      edit_step :has_other_parties
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :other_parties do
      crud_step :names
      crud_step :personal_details, only: [:edit, :update]
      crud_step :contact_details,  only: [:edit, :update]
      edit_step :relationship, only: [] do
        edit_routes ':id/child/:child_id'
      end
    end
    namespace :international do
      edit_step :resident
      edit_step :jurisdiction
      edit_step :request
    end
    namespace :completion do
      show_step :what_next
      show_step :summary
      # The following is an alias of the `what_next` route, for analytics tracking
      get :how_to_submit, to: 'what_next#show'
    end
  end

  resource :session, only: [:destroy] do
    member do
      get :ping
      post :bypass_screener
      post :bypass_to_cya
    end
  end

  resources :status, only: [:index]

  resource :errors, only: [] do
    get :invalid_session
    get :application_not_found
    get :application_screening
    get :application_completed
    get :unhandled
    get :not_found
  end

  root 'steps/screener/start#show'

  get 'entrypoint/v1'
  get 'entrypoint/v2'
  get 'entrypoint/v3'

  get 'entrypoint/what_is_needed'
  get 'entrypoint/how_long'

  get :contact, to: 'home#contact', as: :contact_page
  get :cookies, to: 'home#cookies', as: :cookies_page
  get :miam_exemptions, to: 'home#miam_exemptions', as: :miam_exemptions_page

  # This route is used in court emails to point users to the survey
  get :survey, to: redirect(Rails.configuration.surveys[:success], status: 302)

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
