set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "coins"
set :repository,  "git://github.com/ewg118/numishare.git"
set :scn, :git
set :branch, "uva"

set :deploy_to, "/usr/local/projects/#{application}"
set :deploy_via, :remote_cache

set :normalize_asset_timestamps, false

# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

namespace :solr do
  desc 'Runs the indexer/generate_index.sh script'
  task :index, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path}/indexer && ./generate_index.sh"
  end
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart do; end
end