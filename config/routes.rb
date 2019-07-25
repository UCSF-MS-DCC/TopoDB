Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users

  root 'home#index'

  namespace :home do
    get 'index'
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
