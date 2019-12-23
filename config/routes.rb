Rails.application.routes.draw do
  # get 'homes/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'homes#new'
  resources :homes do

  end		
  get 'generated_sitemap.xml', :to => 'homes#index', :defaults => {:format => 'xml'}

end
