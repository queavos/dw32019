Rails.application.routes.draw do
  get 'rubros/index'
  get 'rubros/new'
  get 'rubros/:id/edit', to: 'rubros#edit', as: 'rubros_edit'
  post 'rubros/create'
  patch 'rubros/update'
  delete 'rubros/:id/delete' , to: 'rubros#delete', as: 'rubros_destroy'
#rutas laboratorios
  get 'laboratorios/index'
  get 'laboratorios/new'
  post 'laboratorios/create'
  get 'laboratorios/edit/:id' , to: 'laboratorios#edit', as: 'laboratorios_edit'
  post 'laboratorios/update'
  get 'laboratorios/delete/:id', to: 'laboratorios#delete', as: 'laboratorios_delete'

  # rutas productos
  get 'productos/index'
  get 'productos/new'
  post 'productos/create'
  get 'productos/edit/:id' , to: 'productos#edit', as: 'productos_edit'
  post 'productos/update'
  get 'productos/delete/:id', to: 'productos#delete', as: 'productos_delete'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
