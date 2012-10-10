SampleDependency::Application.routes.draw do
  
  resources :dependencies
  root :to => 'dependencies#new'
  
end
