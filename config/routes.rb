Rails.application.routes.draw do
  get 'welcome/index'
  get 'inicio', to: 'welcome#index'
  root to: 'welcome#index'

end
