require 'rvm/capistrano'
require 'bundler/capistrano'
require 'capistrano_colors'
require 'delayed/recipes'
require './config/deploy/recipes'

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, 'langtrainer.ru'
set :domain, 'p2.httplab.ru'

#set :project_symlinks, %w(public/assets)

set :user, 'apps'
set :use_sudo, false

set :scm, :git
set :repository, 'git@github.com:beorc/langtrainer.git'
set :branch, 'master'
set :git_shallow_clone, 1

role :web, domain
role :app, domain
role :db, domain, :primary => true

set :deploy_via, :copy
set :copy_exclude, %w(.git)

set :rvm_type, :user
set :rvm_ruby_string, 'ruby-1.9.3'

set :rails_env, :production
set :rack_env, :production

before 'deploy:update_code', 'deploy:asset_sync'
after 'deploy:finalize_update', 'deploy:symlink_shared'
after 'deploy:setup', 'deploy:create_shared_dirs'

after 'deploy', 'deploy:migrate', 'deploy:assets_clean'

after 'deploy:stop', 'delayed_job:stop'
after 'deploy:start', 'delayed_job:start'
after 'deploy:restart', 'delayed_job:restart'

require 'capistrano-unicorn'
require './config/boot'
