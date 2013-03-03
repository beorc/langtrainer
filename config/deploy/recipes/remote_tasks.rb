Capistrano::Configuration.instance(:must_exist).load do

  desc 'run remote command'
  task :remote do
    command = ARGV.values_at(Range.new(ARGV.index('remote')+1, -1))
    run "cd #{current_path}; RAILS_ENV=production bundle exec #{command*' '}"
    exit(0)
  end

  desc 'run specified rails code on server'
  task :runner do
    command = ARGV.values_at(Range.new(ARGV.index('runner')+1, -1))
    run "cd #{current_path}; script/runner '#{command*' '}'"
    exit(0)
  end

  desc "tail production log files"
  task :tail_logs, :roles => :app do
    run "tail -f #{shared_path}/log/#{fetch(:rails_env)}.log" do |channel, stream, data|
      trap("INT") { puts ' Interupted'; exit 0; }
      puts # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end

end