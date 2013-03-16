# encoding=utf-8

Capistrano::Configuration.instance(:must_exist).load do

  namespace :deploy do
    DEFAULT_SYMLINKS = %w(config/database.yml config/application.yml public/uploads public/assets)
    DEFAULT_SHARED_DIRS = 'public public/uploads config sockets'

    desc "Локальная компиляция и синхронизация ассетов с S3"
    task :asset_sync do
      run_locally "rake assets:precompile"
      manifest = 'public/assets/manifest.yml'
      run_locally "scp #{manifest}  #{user}@#{domain}:#{shared_path}/#{manifest}"
    end

    desc "Удалить скомпилированные ассеты"
    task :assets_clean do
      run_locally "rake assets:clean"
    end

    task :create_shared_dirs do
      remote_ruby <<-EOS
        "#{DEFAULT_SHARED_DIRS}".split("\s").each {|d| Dir.mkdir("#{shared_path}/" + d) unless Dir.exist?("#{shared_path}/" + d) }
      EOS
    end

    task :symlink_shared do
      links = exists?(:project_symlinks) ? fetch(:project_symlinks) : []
      project_symlinks = links + DEFAULT_SYMLINKS
      project_symlinks.uniq.each do |link|
        lns(File.join(fetch(:shared_path), link), File.join(fetch(:release_path), link))
      end

      if exists?(:custom_symlinks)
        fetch(:custom_symlinks).each { |s, t| lns(s, t) }
      end
    end

    task :notify_ratchetio, :roles => :app do
      set :revision, `git log -n 1 --pretty=format:"%H"`
      set :local_user, `whoami`
      rails_env = fetch(:rails_env, 'production')
      run "curl https://submit.ratchet.io/api/1/deploy/ -F access_token=#{ratchetio_token} -F environment=#{rails_env} -F revision=#{revision} -F local_username=#{local_user} >/dev/null 2>&1"
    end

  end

    namespace :db do
      desc "Создать конфигурацию DB на основании шаблона"
      task :default_config do
        remote_ruby <<-EOS
        unless File.exist?("#{shared_path}/config/database.yml")
          require "fileutils"
          FileUtils.cp "#{current_release}/config/database.yml.mysql",  "#{shared_path}/config/database.yml"
        end
        EOS
      end
    end

end
