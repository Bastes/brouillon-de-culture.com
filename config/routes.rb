ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resources :keywords, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resources :directions, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resources :sessions

  map.login   'login', :controller => 'sessions', :action => 'new'
  map.logout  'logout', :controller => 'sessions', :action => 'destroy'

  map.bio 'bio.:format', :controller => 'statics', :action => 'bio'

  map.root :controller => 'posts', :action => 'hot'
end
