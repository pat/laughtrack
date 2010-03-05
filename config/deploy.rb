require 'thinking_sphinx/deploy/capistrano'

set :application, "laughtrack"
set :repository,  "git@github.com:freelancing-god/laughtrack.git"

set :scm,       :git
set :user,      application
set :use_sudo,  false

default_run_options[:pty] = true

role :web, "laughtrack.com.au"
role :app, "laughtrack.com.au"
role :db,  "laughtrack.com.au", :primary => true

set :deploy_to, "/var/www/#{application}"
set :bundle,    '/usr/local/ruby-enterprise/bin/bundle'

namespace :deploy do
  task :start do
    #
  end
  
  task :stop do
    #
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

after 'deploy:update' do
  run "cd #{release_path} && #{bundle} install && #{bundle} lock"
end

after 'deploy:symlink' do
  run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end
