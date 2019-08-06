Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root 'home#index'

  namespace :home do
    get 'index'
    get 'cage'
    get 'strain'
    get 'transfer'
    post 'create_cage'
    patch 'update_cage'
    put 'update_mouse'
    put 'new_pups'
    put 'update_mouse_cage'
    get 'transfer_update'
  end

  get '*path', to: 'error#error_404', via: :all, as: 'error'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
