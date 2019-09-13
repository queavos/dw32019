Rails.application.routes.draw do


  root 'main#index'
#rutas de main
  get 'main/index'
  get 'main/saludo'

#rutas archivo
  get 'archivo/index'
  get 'archivo/new'
  post 'archivo/create'
  get 'archivo/edit/:id', to: 'archivo#edit', as: 'archivo_edit'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
