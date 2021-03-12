# config valid only for current version of Capistrano
lock "~> 3.10.1"

def deploysecret(key)
  @deploy_secrets_yml ||= YAML.load_file("config/deploy-secrets.yml")[fetch(:stage).to_s]
  @deploy_secrets_yml.fetch(key.to_s, "undefined")
end

set :rails_env, fetch(:stage)
set :rvm1_map_bins, -> { fetch(:rvm_map_bins).to_a.concat(%w[rake gem bundle ruby]).uniq }

set :application, "consul"
set :full_app_name, deploysecret(:full_app_name)
set :deploy_to, deploysecret(:deploy_to)
set :server_name, deploysecret(:server_name)
set :repo_url, 'https://github.com/LauraConcepcion/consulLPA.git'

set :revision, `git rev-parse --short #{fetch(:branch)}`.strip

set :log_level, :info
set :pty, true
set :use_sudo, false

set :linked_files, %w{config/database.yml config/secrets.yml config/environments/production.rb lib/custom/census_api.rb}
set :linked_dirs, %w{log tmp public/system public/assets public/ckeditor_assets}

set :keep_releases, 5

set :local_user, ENV["USER"]

set :puma_conf, "#{release_path}/config/puma/#{fetch(:rails_env)}.rb"

set :delayed_job_workers, 2
set :delayed_job_roles, :background

set(:config_files, %w[
  log_rotation
  database.yml
  secrets.yml
])

set :whenever_roles, -> { :app }

namespace :deploy do
  #before :starting, 'rvm1:install:rvm'  # install/update RVM
  #before :starting, 'rvm1:install:ruby' # install Ruby and create gemset
  #before :starting, 'install_bundler_gem' # install bundler gem
  before :starting, 'install_bundler_gem' # install bundler gem

  # after :publishing, 'deploy:restart'
  after :published, 'delayed_job:restart'
  # after :published, 'refresh_sitemap'
  after :publishing, 'restart_tmp'
  # after "deploy:migrate", "add_new_settings"
  # after :publishing, "deploy:restart"
  # after :published, "delayed_job:restart"
  # after :published, "refresh_sitemap"
  # after :updating, "rvm1:install:rvm"
  # after :updating, "rvm1:install:ruby"
  # after :updating, "install_bundler_gem"
  # before "deploy:migrate", "remove_local_census_records_duplicates"

  # after "deploy:migrate", "add_new_settings"
  # Rake::Task["delayed_job:default"].clear_actions
  # Rake::Task["puma:smart_restart"].clear_actions

  # after :updating, "rvm1:install:rvm"
  # after :updating, "rvm1:install:ruby"
  # after :updating, "install_bundler_gem"

  # after "deploy:migrate", "add_new_settings"

  after  :publishing, "setup_puma"

  after :published, "deploy:restart"
  before "deploy:restart", "puma:restart"
  before "deploy:restart", "delayed_job:restart"
  before "deploy:restart", "puma:start"

  after :finished, "refresh_sitemap"

  desc "Deploys and runs the tasks needed to upgrade to a new release"
  task :upgrade do
    after "add_new_settings", "execute_release_tasks"
    invoke "deploy"
  end
end

# RVM is already installed on server, so these lines are not needed
# task :update_rvm_key do
#   on roles(:app) do
#     execute :gpg, "--keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3"
#   end
# end


task :install_bundler_gem do
  on roles(:app) do
    execute "cd #{release_path} && #{fetch(:rvm1_auto_script_path)}/rvm-auto.sh . gem install bundler"
   # execute "rvm use #{fetch(:rvm1_ruby_version)}; gem install bundler"
    # within release_path do
    #   execute :rvm, fetch(:rvm1_ruby_version), "do", "gem install bundler --version 1.17.1"
    # end
  end
end

task :refresh_sitemap do
  on roles(:app) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "sitemap:refresh:no_ping"
      end
    end
  end
end

task :add_new_settings do
  on roles(:db) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "settings:add_new_settings"
      end
    end
  end
end

task :execute_release_tasks do
  on roles(:app) do
    within release_path do
      with rails_env: fetch(:rails_env) do
        execute :rake, "consul:execute_release_tasks"
      end
    end
  end
end

desc "Restart application"
task :restart_tmp do
  on roles(:app) do
  execute "touch #{ File.join(current_path, 'tmp', 'restart.txt') }"
  end
end

desc "Create pid and socket folders needed by puma"
task :setup_puma do
  on roles(:app) do
    with rails_env: fetch(:rails_env) do
      execute "mkdir -p #{shared_path}/tmp/sockets; true"
      execute "mkdir -p #{shared_path}/tmp/pids; true"
    end
  end
end
