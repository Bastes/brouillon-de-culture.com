ActionController::Routing::Routes.draw do |map|
  map.resources :posts, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resources :keywords, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resources :directions, :collection => { :hot => :get }, :member => { :remove => :get }
  map.resource  :session, :controller => 'session', :only => [ :new, :create, :destroy ]

  map.login 'login', :controller => 'session', :action => 'new'
  map.logout 'logout', :controller => 'session', :action => 'destroy'

  map.bio 'bio.:format', :controller => 'statics', :action => 'bio'

  map.root :controller => 'posts', :action => 'hot'
end
