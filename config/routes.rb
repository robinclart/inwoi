Inwoi::Application.routes.draw do
  get :signup, to: 'signups#new', as: 'signup'
  post :signup, to: 'signups#create'
  get :login, to: 'sessions#new', as: 'login'
  post :login, to: 'sessions#create'
  delete :login, to: 'sessions#destroy'
  resources :accounts do
    resources :invoices
  end
end
