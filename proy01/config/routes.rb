Rails.application.routes.draw do


  root 'main#index'
#rutas de main
  get 'main/index'
  get 'main/saludo'

#rutas archivo
  get 'archivo/index'
  post 'archivo/read'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
