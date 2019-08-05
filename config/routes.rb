Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root 'home#index'

  namespace :home do
    get 'index'
    get 'cage'
    get 'strain'
    post 'create_cage'
    patch 'update_cage'
    put 'euthanize_mice'
    post 'update_mouse'
    get 'transfer'
    put 'new_pups'
  end

  get '*path', to: 'error#error_404', via: :all, as: 'error'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
