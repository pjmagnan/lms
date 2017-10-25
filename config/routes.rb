Rails.application.routes.draw do
  filter :locale

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get 'avatar/:size/:background/:text' => Dragonfly.app.endpoint { |params, app|
    app.generate(:initial_avatar, CGI.unescape(params[:text]),
                 size: params[:size], background_color: params[:background])
  }, as: :avatar

  resources :settings

  resources :users, concerns: :paginatable do
    resources :assignments, only: %w[show]
  end

  resources :courses do
    resources :enrolments, except: %w[index show update edit]
    resources :assignments, except: %w[index]
  end

  resources :sessions, only: %w[create]
  resources :password_resets, only: %w[edit create update]

  get '/login', to: 'sessions#new', as: :login
  get '/logout', to: 'sessions#destroy', as: :logout

  root to: 'pages#dashboard'
end
