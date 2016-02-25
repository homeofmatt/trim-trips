# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'trim-trips'
set :repo_url, 'git@github.com:homeofmatt/trim-trips.git'
set :use_sudo, false
set :bundle_binstubs, nil

set :port, 22
set :user, 'deployer'
set :rbenv_ruby, '2.3.0'
set :deploy_via, :remote_cache

set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :tmp_dir, "/home/deployer/tmp"

set :ssh_options, {
  forward_agent: true,
  auth_methods: %w(publickey),
  user: 'deployer'
}

set :rails_env, :production
set :conditionally_migrate, true

server '45.55.29.180',
  roles: [:web, :app, :db],
  port: fetch(:port),
  user: fetch(:user),
  primary: true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

after 'deploy:publishing', 'deploy:restart'

namespace :deploy do
  desc "Restart the app"
  task :restart do
    invoke 'unicorn:reload'
  end

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
