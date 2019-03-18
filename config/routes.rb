Rails.application.routes.draw do
  #TODO
  resources :announcements, only: %i[create index show] do
    resources :responses, only: %i[create] do
      member do
        put :cancel
        put :accept
      end
    end

    member do
      put :cancel
    end
  end
end
