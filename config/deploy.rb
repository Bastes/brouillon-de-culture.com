# setting git repository informations
set :scm,                   "git"
set :repository,            "git@github.com:Bastes/brouillon-de-culture.com.git"
set :scm_username,          "Bastes"
set :branch,                "deploy"
set :git_enable_submodules, 1

# setting dreamhost host informations
set :user,            "bastes_blog"
set :domain,          "brouillon-de-culture.com"
set :project,         "brouillon-de-culture.com"
set :application,     "brouillon-de-culture.com"
set :application_dir, "/home/#{user}/#{application}"

# setting dreamhost database informations
set :template_dir,      ""
set :database_schema,   "bastes_blog_production"
set :database_username, "bastes_blog"
set :database_host,     "mysql.brouillon-de-culture.com"
set :database_port,     3306

# roles (servers)
role :web, domain
role :app, domain
role :db,  domain, :primary => true

# deploy config
set :deploy_to,  application_dir
set :deploy_via, :remote_cache

# additional settings
ssh_options[:forward_agent] = true
ssh_options[:keys]          = %w(~/.ssh/id_rsa)
default_environment['GIT_SSL_NO_VERIFY'] = 'true' # anonymous submodules import
set :chmod755,  "app config db lib public vendor script script/* public/disp*"
set :use_sudo, false


before "deploy:setup", "db:configure"
before "deploy:setup", "user:configure"
after "deploy:update_code", "db:symlink"
after "deploy:update_code", "gems:unpack"
after "deploy:update_code", "db:migrate"
after "deploy:update_code", "user:symlink"
 
namespace :user do
  desc "Create user credentials file in shared path"
  task :configure do
    user_config = <<-EOF
ADMIN_LOGIN    = '#{Capistrano::CLI.ui.ask("Enter admin login: ")}'
ADMIN_PASSWORD = '#{Capistrano::CLI.ui.ask("Enter admin password: ")}'
EOF
    run "mkdir -p #{File.join(shared_path, 'config', 'initializers')}"
    put user_config, File.join(shared_path, 'config', 'initializers', 'admin_credentials.rb')
  end

  desc "Make symlink for admin credentials."
  task :symlink do
    run "ln -nfs #{File.join(shared_path, 'config', 'initializers', 'admin_credentials.rb')} #{File.join(latest_release, 'config', 'initializers', 'admin_credentials.rb')}"
  end
end

namespace :gems do
  desc "Unpack gems"
  task :unpack do
    run "rake -f #{File.join(latest_release, 'Rakefile')} gems:unpack"
  end
end

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    db_config = <<-EOF
base: &base
  adapter:  sqlite3
  timeout:  5000
development:
  database: #{shared_path}/db/development.sqlite3
  <<: *base
test:
  database: #{shared_path}/db/test.sqlite3
  <<: *base
production:
  adapter:  mysql
  host:     #{database_host}
  port:     #{database_port}
  database: #{database_schema}
  username: #{database_username}
  password: #{Capistrano::CLI.ui.ask("Enter MySQL database password: ")}
  encoding: utf8
  timeout:  5000
EOF
    run "mkdir -p #{shared_path}/config"
    put db_config, File.join(shared_path, 'config', 'database.yml')
  end
 
  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{File.join(shared_path, 'config', 'database.yml')} #{File.join(latest_release, 'config', 'database.yml')}"
  end

  desc "Migrate database"
  task :migrate do
    run "rake -f #{File.join(latest_release, 'Rakefile')} db:migrate RAILS_ENV=production"
  end
end

namespace :deploy do
  task :start do
  end
  task :stop do
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end
end

