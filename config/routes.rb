ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :member => { :remove => :get }
  map.resources :sessions

  map.login   'login', :controller => 'sessions', :action => 'new'
  map.logout  'logout', :controller => 'sessions', :action => 'destroy'
  map.root :controller => 'posts', :action => 'index'
end
