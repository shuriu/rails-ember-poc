Rails.application.routes.draw do
  resources :boards, defaults: { format: :jsonapi }
  resources :columns, defaults: { format: :jsonapi }
  resources :tasks, defaults: { format: :jsonapi }

  resources :users, only: [:show] do
    get :current, on: :collection
  end

  resources :sessions, only: [:create] do
    delete  :destroy, on: :collection, as: :logout
  end
end
