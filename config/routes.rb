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
    put 'remove_mouse'
    put 'update_tail_cut_date'
    get 'transfer_update'
    get 'assign_new_ids'
  end

  namespace :archive do
    get 'index'
  end

  namespace :error do
    get 'error_404'
  end

  get '*path', to: 'error#error_404', via: :all, as: 'error'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
