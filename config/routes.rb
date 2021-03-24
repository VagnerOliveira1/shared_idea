Rails.application.routes.draw do
  namespace :site do
    get 'welcome/index'
  end
  namespace :users_backoffice do
    get 'welcome/index'
  end
  namespace :admins_backoffice do
    get 'welcome/index'
    resources :admins, except: [:delete]
  end

  devise_for :users
  devise_for :admins
  devise_scope :admin do
    get '/admins/sign_out' => 'devise/sessions#destroy'
 end
  get 'inicio', to: 'site/welcome#index'
  root to: 'site/welcome#index'
end
