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

  namespace :steps do
    namespace :application do
      edit_step :without_notice
      edit_step :without_notice_details
      edit_step :litigation_capacity
      edit_step :litigation_capacity_details
      edit_step :special_assistance
      edit_step :special_arrangements
    end
    namespace :petition do
      edit_step :orders
      show_step :playback
    end
    namespace :miam do
      edit_step :consent_order
      show_step :consent_order_sought
      edit_step :child_protection_cases
      show_step :child_protection_info
      edit_step :acknowledgement
      edit_step :attended
      show_step :not_attended_info
      edit_step :certification
      show_step :no_certification_info
      edit_step :certification_date
      show_step :certification_expired_info
      edit_step :certification_number
      show_step :certification_confirmation
    end
    namespace :abduction do
      edit_step :children_have_passport
      edit_step :international
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
      edit_step :question do
        get '/:subject/:kind', action: :edit
      end
      edit_step :details do
        get '/:subject/:kind', action: :edit
      end
      edit_step :contact
      edit_step :previous_proceedings
      edit_step :emergency_proceedings
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
      edit_step :user_type
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
    namespace :help_with_fees do
      edit_step :help_paying
    end
  end

  resource :session, only: [:destroy] do
    member do
      get :ping
    end
  end

  resources :status, only: [:index]

  resource :errors, only: [] do
    get :invalid_session
    get :unhandled
  end

  root to: 'entrypoint#v1'

  get 'entrypoint/v1'
  get 'entrypoint/v2'
  get 'entrypoint/v3'

  get 'entrypoint/what_is_needed'
  get 'entrypoint/how_long'

  get :contact, to: 'home#contact', as: :contact_page
  get :cookies, to: 'home#cookies', as: :cookies_page
  get :miam_exemptions, to: 'home#miam_exemptions', as: :miam_exemptions_page

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
