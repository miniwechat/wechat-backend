Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :api do
    get '/scan/index', to: 'wechat#index'
    get '/scan/create/:id' ,to: 'wechat#create'
    get '/scan/update/:id', to: 'wechat#update'
    get '/scan/delete/:id', to: 'wechat#delete'
    get '/scan/decode', to: 'wechat#decode'
  end

  namespace :secret do
    get '/frontcode/confirm',to: 'sessions#confirm'
    get '/frontcode/create/:id',to: 'sessions#create'
    get '/frontcode/index',to: 'sessions#index'
    get '/frontcode/sign/' ,to: 'signature#confirm'
    get '/frontcode/scan/' ,to: 'signature#scan'
    get '/frontcode/indexs/' ,to: 'signature#index'
    get '/frontcode/test/' ,to: 'signature#test'
    get '/test/upload', to: 'photo#upload'
  end

  scope :photo do
    get '/index', to: 'photo#index'
    get '/upload/', to: 'photo#upload'
  end

end
