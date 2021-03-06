Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root 'home#index'

  namespace :home do
    get 'index'
    get 'search'
    get 'main'
    get 'cage'
    get 'mouse'
    get 'strain'
    get 'strain_table'
    post 'create_cage'
    patch 'update_cage'
    post 'create_mouse'
    put 'update_mouse'
    put 'new_pups'
    put 'update_mouse_cage'
    put 'remove_mouse'
    put 'update_tail_cut_date'
    get 'assign_new_ids'
    get 'removed_mouse_index'
    post 'restore_mouse'
    get 'graph_data_sex'
    get 'graph_data_age'
    get 'cage_timeline_dates'
  end

  resources :cage do
    post 'create_pups'
    patch 'file_store'
    post 'delete_attachment'
    get 'download_file'
    resources :mouse
  end

  resources :experiment do 
    post 'add_data'
    put 'update_data'
    post 'add_new_datapoint'
    resources :mouse do
      resource :datapoint do 
      end
    end
  end

  namespace :audit do
    get 'index'
    get 'mouse'
    get 'cage'
    get 'experiment'
    get 'mouse_version'
    get 'cage_version'
    post 'restore_mouse_version'
    post 'restore_cage_version'
  end

  namespace :archive do
    get 'index'
  end

  namespace :error do
    get 'error_404'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
