Rails.application.routes.draw do
  resources :cities
  resources :ciudades
  resources :paises
  get 'personas/index'
  get 'personas/new'
  post 'personas/create'
  get 'personas/:id/edit', to: 'personas#edit', as: 'personas_edit'
  patch 'personas/update'
  delete 'personas/:id/delete', to: 'personas#delete', as: 'personas_delete'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
