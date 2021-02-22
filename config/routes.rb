Rails.application.routes.draw do
  mount Panicboat::Engine, at: '/panicboat'

  resources :health,        only: %i[index]
  resources :agencies,      only: %i[index show create update destroy]
  resources :advertisers,   only: %i[index show create update destroy]
  resources :products,      only: %i[index show create update destroy]
  resources :campaigns,     only: %i[index show create update destroy] do
    resources :events,      only: %i[index show create update destroy]
  end
  resources :banners,       only: %i[index show create update destroy] do
    resources :details,     only: %i[index show create update destroy], controller: 'banner_details'
  end
  resources :budgets,       only: %i[index show create update destroy] do
    resources :details,     only: %i[index show create update destroy], controller: 'budget_details'
  end
  resources :achievements,  only: %i[index show create update destroy] do
    resources :details,     only: %i[index show create update destroy], controller: 'achievement_details'
  end
  resources :measurements,  only: %i[index show create update destroy] do
    resources :details,     only: %i[index show create update destroy], controller: 'measurement_details'
  end
  resources :princiapals, only: %i[index create destroy], controller: 'campaign_principals' do
    resources :achievements,  only: %i[index create destroy], controller: 'achievement_principals'
    resources :measurements,  only: %i[index create destroy], controller: 'measurement_principals'
  end
end
