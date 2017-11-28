# :nocov:
class ActionDispatch::Routing::Mapper
  def edit_step(name, opts = {}, &block)
    resource name,
             only:       [:edit, :update],
             controller: name,
             path_names: { edit: '' } do

      resources only:       [:edit, :update, :destroy],
                controller: name,
                path_names: { edit: '' } if opts.fetch(:enable_crud, false)

      block.call if block_given?
    end
  end

  def show_step(name)
    resource name,
             only:       [:show],
             controller: name
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
    namespace :petition do
      edit_step :orders
      edit_step :other_issue
    end
    namespace :miam do
      edit_step :acknowledgement
      edit_step :attended
      show_step :not_attended_info
      edit_step :certification
      show_step :no_certification_kickout
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
      edit_step :risk_of_abduction
      edit_step :substance_abuse
      edit_step :substance_abuse_details
      edit_step :children_abuse
      edit_step :domestic_abuse
      edit_step :other_abuse
    end
    namespace :abuse_concerns do
      show_step :start
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
      edit_step :negotiation_tools
      edit_step :mediation
    end
    namespace :children do
      show_step :instructions
      edit_step :personal_details, enable_crud: true
      edit_step :additional_details
    end
    namespace :applicant do
      edit_step :user_type
      edit_step :number_of_children
      edit_step :personal_details, enable_crud: true
    end
    namespace :respondent do
      edit_step :personal_details, enable_crud: true
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

  get :contact, to: 'home#contact', as: :contact_page
  get :cookies, to: 'home#cookies', as: :cookies_page

  # catch-all route
  # :nocov:
  match '*path', to: 'errors#not_found', via: :all, constraints:
    lambda { |_request| !Rails.application.config.consider_all_requests_local }
  # :nocov:
end
